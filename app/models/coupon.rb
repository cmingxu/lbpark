# == Schema Information
#
# Table name: coupons
#
#  id                :integer          not null, primary key
#  park_id           :integer
#  coupon_tpl_id     :integer
#  identifier        :string(255)
#  user_id           :integer
#  status            :string(255)
#  end_at            :datetime
#  price             :integer
#  issued_address    :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  claimed_at        :datetime
#  fit_for_date      :date
#  coupon_tpl_type   :string(255)
#  expire_at         :datetime
#  qr_code           :string(255)
#  issued_begin_date :date
#  used_at           :datetime
#  issued_paizhao    :string(255)
#  quantity          :integer
#  issued_park_space :string(255)
#

class Coupon < ActiveRecord::Base
  COUPON_STATUS = {
    :created => "已创建",
    :claimed => "已领取",
    :used    => "已使用",
    :expired => "已过期",
    :ordered => "未付款"
  }

  belongs_to :coupon_tpl
  belongs_to :park
  belongs_to :user
  has_many :order

  after_create :generate_qr_code
  scope :display_order, lambda { order("coupon_tpl_type, price ASC, claimed_at DESC") }
  scope :claimed, lambda { where(:status => :claimed) }
  scope :claimed_or_used, lambda { where("status in ('claimed', 'used')") }
  scope :used, lambda { where(:status => :used) }
  scope :fit_for_today, lambda { where(["fit_for_date = ? ", Time.now.strftime("%Y-%m-%d") ]) }
  scope :long_term_or_fit_for_today, lambda { where(["fit_for_date is NULL or fit_for_date = ? ", Time.now.strftime("%Y-%m-%d")]) }
  scope :expired, lambda { where(["fit_for_date < ?", Time.now.strftime("%Y-%m-%d")]) }

  mount_uploader :qr_code, CouponQrCodeUploader

  COUPON_STATUS.keys.each { |s| scope s, -> { where(:status => s) } }

  delegate :free?,:monthly?, :time?, :deduct?, :exchangeable?, :to => :coupon_tpl

  state_machine :status, :initial => :created do
    after_transition :on => :claim, :do => :after_claim
    after_transition :on => :pay, :do => :after_claim
    after_transition :on => :use, :do => :after_use
    after_transition :on => :order, :do => :clear_order_data_if_not_paid
    after_transition :on => :order, :do => :after_order

    event :order do
      transition :from => :created, :to => :ordered
    end

    event :pay do
      transition :from => :ordered, :to => :claimed
    end

    event :claim do
      transition :from => :created, :to => :claimed
    end

    event :use do
      transition :from => :claimed, :to => :used
    end
  end

  def after_claim
    self.update_column :claimed_at, Time.now
    self.update_column :expire_at, self.fit_for_date.end_of_day if self.free?
    self.update_column :expire_at, self.fit_for_date.end_of_day if self.deduct?
    #self.update_column :expire_at, 10.years.from_now if self.time?
    #self.update_column :expire_at, (self.issued_begin_date.to_time + self.quantity.month - 1.day).end_of_day if self.monthly?
  end

  def after_use
    self.update_column :used_at, Time.now
  end

  def after_order
    self.update_column :expire_at, (self.issued_begin_date.to_time + self.quantity.month - 1.day).end_of_day if self.monthly?
    self.update_column :expire_at, 10.years.from_now if self.time?
  end

  def clear_order_data_if_not_paid
    # clear order if not paid after 120.mins
    Resque.enqueue_at Time.now + 120 * 60, OrderClearTask, self.id
  end

  def expired?
    Time.now > expire_at
  end

  def as_api_json(location)
    distance = LbRange.new(location, self.coupon_tpl.park.location).distance
    distance = distance > Settings.coupons_visible_range ? "很远" : "#{distance}米"
    {
      :id => id,
      :price     => self.price || 0,
      :distance  => distance,
      :park_name => self.coupon_tpl.park.name,
      :park_type => self.coupon_tpl.park.park_type,
      :expired   => expired?,
      :used      => used?,
      :notice => self.coupon_tpl.notice,
      :displayable_label => self.coupon_tpl.type_name_in_zh,
      :limitation => self.coupon_tpl.limitation,
      :icon => park.park_pics.first.park_pic.thumb.url,
      :paid => self.status == "clamied" ? true : false,
      :order_id => order.try(:id)
    }
  end

  def time_span
    return self.coupon_tpl.time_span if !self.monthly?
    "#{self.issued_begin_date.to_time.to_s(:lb_cn_short)}-#{self.expire_at.to_s(:lb_cn_short)}"
  end

  def can_use?(park)
    return false if !self.claimed?
    return false if self.park_id != park.id
    return false if expired?
    return true
  end

  def coupon_use!
    return true if self.monthly?
    self.use!
  end

  def fit_for_date_range
    if self.free?
      self.fit_for_date.to_time.to_s(:lb_cn_short)
    else
      "#{self.expire_at.to_s(:lb_cn_short)}前"
    end
  end

  class QrCodeIo < StringIO
    attr_accessor :original_filename
    attr_accessor :content_type
  end

  def generate_qr_code
    qr = ::RQRCode::QRCode.new(self.identifier)
    png = qr.to_img
    sio = QrCodeIo.new
    sio.original_filename = "qr.png"
    png.resize(256, 256).write(sio)
    self.qr_code = sio
    self.save
  end
end
