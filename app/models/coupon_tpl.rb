# == Schema Information
#
# Table name: coupon_tpls
#
#  id         :integer          not null, primary key
#  park_id    :integer
#  staff_id   :integer
#  type       :string(255)
#  identifier :string(255)
#  name_cn    :string(255)
#  end_at     :datetime
#  gcj_lat    :decimal(10, 6)
#  gcj_lng    :decimal(10, 6)
#  quantity   :integer
#  copy_from  :integer
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class CouponTpl < ActiveRecord::Base
  HIHGLIGHT_PRIORITY = 1000
  DEFAULT_PRIORITY   = 0

  COUPON_TPL_TYPES = {
    :free => "限免",
    :monthly => "按月",
    :quarterly => "按季"
  }

  COUPON_TPL_STATUS = {
    :published => "发布中",
    :draft => "未发布",
    :stopped => "已停止"
  }

  belongs_to :park
  belongs_to :staff
  has_many :coupons

  validates :park_id, presence: { :message => "停车场不能空" }
  validates :quantity, presence: { :message => "数量不能空" }
  validates :identifier, uniqueness: true, :on => :create
  validates :quantity, numericality: { :gt => 0, :message => "数量大于零" }

  before_save :set_defaults, :on => :update
  after_create :generate_all_new_coupon

  scope :highlighted, -> { where(:priority => HIHGLIGHT_PRIORITY)}
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

  def self.coupon_class_name(type)
    "CouponTpl::#{type.to_s.capitalize}CouponTpl".constantize
  end

  def self.coupon_type_to_readable(type)
    type.scan(/CouponTpl::(\w+)CouponTpl/).first.first.downcase
  end

  def self.identifier(type)
    type.to_s[0].upcase + sprintf("%04d", coupon_class_name(type).send(:count) + 1)
  end

  def stop_all_related_coupon
  end

  def generate_all_new_coupon
    self.quantity.times do
      self.coupons.create do |c|
        c.park_id = self.park_id
        c.identifier = self.identifier + "_" + SecureRandom.hex(20)
      end
    end
  end

  def can_be_claimed_by?(user)
    true
  end

  def claim
    coupons.created.first
  end

  def claimed_count
    self.coupons.claimed.count
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

  def highlighted?
    self.priority == HIHGLIGHT_PRIORITY
  end

  def set_defaults
    self.priority = DEFAULT_PRIORITY
    self.gcj_lng = self.park.gcj_lng
    self.gcj_lat = self.park.gcj_lat
    self.identifier = CouponTpl.identifier(self.class.coupon_type_to_readable(self.type))
  end
end
