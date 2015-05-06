# == Schema Information
#
# Table name: coupon_tpls
#
#  id                     :integer          not null, primary key
#  park_id                :integer
#  priority               :integer
#  staff_id               :integer
#  type                   :string(255)
#  identifier             :string(255)
#  name_cn                :string(255)
#  fit_for_date           :date
#  end_at                 :datetime
#  gcj_lat                :decimal(10, 6)
#  gcj_lng                :decimal(10, 6)
#  quantity               :integer
#  price                  :integer
#  copy_from              :integer
#  status                 :string(255)
#  published_at           :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  banner                 :string(255)
#  notice                 :string(255)
#  coupon_value           :integer
#  valid_hour_begin       :integer
#  valid_hour_end         :integer
#  lower_limit_for_deduct :integer
#  valid_dates            :string(255)
#

class CouponTpl < ActiveRecord::Base
  HIHGLIGHT_PRIORITY = 1000
  DEFAULT_PRIORITY   = 0

  COUPON_TPL_TYPES = {
    :monthly => "包月",
    :free => "限免",
    :time => "按次",
    :deduct => "满额抵减"
    #:redeemable => "代金",
    #:exchangeable => "优惠"
  }

  COUPON_TPL_STATUS = {
    :published => "发布中",
    :draft => "未发布",
    :stopped => "已停止"
  }

  VALID_DATES = [
    "周一至周五",
    "周六日",
    "全天可用"
  ]

  VALID_DATES_FOR_MONTHLY = [
    "全天可用",
    "白天可用",
    "夜间可用"
  ]

  belongs_to :park
  belongs_to :staff
  has_many :coupons
  has_many :park_notice_items, :dependent => :destroy

  validates :park_id, presence: { :message => "停车场不能空" }
  validates :quantity, presence: { :message => "数量不能空" }
  validates :identifier, uniqueness: true, :on => :create
  validates :quantity, numericality: { :gt => 0, :message => "数量大于零" }
  validates :fit_for_date, uniqueness: { :scope => [:park_id, :status], :message => "免费券日期重复了", :if => lambda { type =~ /free/i} }

  before_create :set_defaults
  after_commit :generate_all_new_coupon_job, :on => :create
  #validate :fit_for_date_gt_then_today
  validates :fit_for_date, presence: { :if => lambda { self.free? }, :message => "限免券需要提供日期"}

  mount_uploader :banner, CouponTplBannerUploader

  #default_scope lambda { order("priority desc, fit_for_date ASC, type")}
  scope :highlighted, -> { where(:priority => HIHGLIGHT_PRIORITY)}
  scope :time_range_right, -> { where(["fit_for_date is NULL OR fit_for_date = ?", Time.now.strftime("%Y-%m-%d")]) }
  scope :for_today, -> { where(["fit_for_date = ?", Time.now.strftime("%Y-%m-%d")]) }
  scope :published, -> { where(:status => "published") }
  scope :within_range, lambda {|range| where(["gcj_lng > ? AND gcj_lat > ? AND gcj_lng < ? AND gcj_lat <?", range.p1.lng, range.p1.lat, range.p2.lng, range.p2.lat]).limit(200) }

  state_machine :status, :initial => :draft do
    after_transition :on => :stopped, :do => :stop_all_related_coupon

    event :publish do
      transition :from => [:draft, :stopped], :to => :published
    end

    event :stop do
      transition :from => [:published], :to => :stopped
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "CouponTpl")
  end

  def self.all_visible_around(location)
    @highlighted_coupon_tpls = CouponTpl.highlighted.time_range_right
    @free_coupon_tpls        = CouponTpl::FreeCouponTpl.published.within_range(location.around(Settings.coupons_visible_range)).for_today - @highlighted_coupon_tpls
    @time_coupon_tpls        = CouponTpl::TimeCouponTpl.published.within_range(location.around(Settings.coupons_visible_range)) - @highlighted_coupon_tpls
    @deduct_coupon_tpls        = CouponTpl::DeductCouponTpl.published.within_range(location.around(Settings.coupons_visible_range)).for_today - @highlighted_coupon_tpls
    @redeemable_coupon_tpls    = CouponTpl::RedeemableCouponTpl.published.within_range(location.around(Settings.coupons_visible_range)).for_today - @highlighted_coupon_tpls
    @long_term_coupon_tpls   = CouponTpl::LongTermCouponTpl.published.within_range(location.around(Settings.coupons_visible_range)) - @highlighted_coupon_tpls
    [ @highlighted_coupon_tpls, @free_coupon_tpls, @long_term_coupon_tpls, @time_coupon_tpls, @deduct_coupon_tpls, @redeemable_coupon_tpls ].flatten.sort_by{|a| a.sort_criteria(location)}.reverse
  end

  def self.coupon_class_name(type)
    "CouponTpl::#{type.to_s.capitalize}CouponTpl".constantize
  end

  def self.coupon_type_to_readable(type)
    type.scan(/CouponTpl::(\w+)CouponTpl/).first.first.downcase
  end

  def self.identifier(type)
    type.to_s[0].upcase + sprintf("%04d", coupon_class_name(type).send(:count))
  end

  COUPON_TPL_TYPES.keys.each do |t|
    define_method "#{t.to_s}?" do
      false
    end
  end

  def as_api_json(location)
    distance = LbRange.new(location, park.location).distance
    distance = distance > Settings.coupons_visible_range ? "很远" : "#{distance}米"
    {
      :id => id,
      :price => price || 0,
      :distance => distance,
      :park_name => park.name,
      :park_type => park.park_type,
      :notice => notice,
      :displayable_label => type_name_in_zh,
      :limitation => limitation,
      :icon => park.park_pics.first.park_pic.thumb.url
    }
  end

  def limitation
    return "全天可用" if self.valid_dates == "全天可用"
    return "限" + self.valid_dates if self.valid_dates
    return "限#{self.valid_hour_begin}:00-#{self.valid_hour_end}:00" if self.valid_hour_begin
    return "全天可用"
  end

  def fit_for_park?(p)
    self.park_id == p.id ||
      self.park.code == p.same_as
  end

  def stop_all_related_coupon
  end

  def generate_all_new_coupon
    self.quantity.times do
      self.coupons.create do |c|
        c.park_id         = self.park_id
        c.identifier      = self.identifier + "" + sprintf("%010d", rand(10**9))
        c.coupon_tpl_type = self.type
        c.fit_for_date    = self.fit_for_date
        c.price           = self.price || 0
      end
    end
  end

  def generate_all_new_coupon_job
    if Rails.env.production?
      Resque.enqueue_at Time.now, CouponGenerationJob, self.id
    else
      generate_all_new_coupon
    end
  end

  def can_be_claimed_by?(user)
    has_enough_coupon? && !claimed_by_user?(user)
  end

  def claim_coupon
    coupons.where(:status => :created).first
  end

  def claimable_count
    self.coupons.where(:status => :created).count
  end

  def not_paid_count
    self.coupons.where(:status => :ordered).count
  end

  def has_enough_coupon?
    claimable_count > 0
  end

  def claimed_by_user?(user)
    self.coupons.claimed_or_used.exists?(:user_id => user.id)
  end

  def user_claimed(user)
    self.coupons.claimed.where(:user_id => user.id).first
  end

  def used_count
    self.coupons.used.count
  end

  def highlight!
    self.update_column :priority, HIHGLIGHT_PRIORITY
  end

  def dehighlight!
    self.update_column :priority, DEFAULT_PRIORITY
  end

  def sort_criteria(location)
    weight = 0
    weight += 100000000 if self.highlighted?
    weight += 10000000 if self.price.nil? or self.price.zero?
    weight += self.price * -1000000 if self.price && self.price > 0
    weight -= LbRange.new(self.park.location, location).distance
    weight
  end

  def highlighted?
    self.priority == HIHGLIGHT_PRIORITY
  end

  def fit_for_date_gt_then_today
    self.errors.add(:fit_for_date, "使用日期不正确") if self.fit_for_date  && self.fit_for_date < Date.today
  end

  def set_defaults
    self.priority = DEFAULT_PRIORITY
    self.gcj_lng = self.park.gcj_lng
    self.gcj_lat = self.park.gcj_lat
    self.identifier = CouponTpl.identifier(self.class.coupon_type_to_readable(self.type))
  end
end
