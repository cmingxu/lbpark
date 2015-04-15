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
#

class Coupon < ActiveRecord::Base
  COUPON_STATUS = {
    :created => "已创建",
    :claimed => "已领取",
    :used    => "已使用",
    :expired => "已过期"
  }

  belongs_to :coupon_tpl
  belongs_to :park

  after_create :generate_qr_code
  scope :display_order, lambda { order("coupon_tpl_type, price ASC, claimed_at DESC") }
  scope :claimed, lambda { where(:status => :claimed) }
  scope :used, lambda { where(:status => :used) }
  scope :fit_for_today, lambda { where(["fit_for_date = ? ", Time.now.strftime("%Y-%m-%d") ]) }
  scope :long_term_or_fit_for_today_or_tomorrow, lambda { where(["fit_for_date is NULL or fit_for_date = ? OR fit_for_date = ?", Time.now.strftime("%Y-%m-%d"), Time.now.tomorrow.strftime("%Y-%m-%d") ]) }
  scope :expired, lambda { where(["fit_for_date < ?", Time.now.strftime("%Y-%m-%d")]) }

  mount_uploader :qr_code, CouponQrCodeUploader

  COUPON_STATUS.keys.each { |s| scope s, -> { where(:status => s) } }

  delegate :free?, :monthly?, :quarterly?, :to => :coupon_tpl

  state_machine :status, :initial => :created do
    after_transition :on => :claim, :do => :after_claim
    after_transition :on => :use, :do => :after_use

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
    self.update_column :expire_at, Time.now + 1.month if self.monthly?
    self.update_column :expire_at, Time.now + 3.month if self.quarterly?
  end

  def after_use
    self.update_column :used_at, Time.now
  end

  def expired?
    Time.now > expire_at
  end

  def as_api_json(location)
    distance = LbRange.new(location, self.coupon_tpl.park.location).distance
    distance = "很远" if distance > Settings.coupons_visible_range
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
      :icon => park.park_pics.first.park_pic.thumb.url
    }
  end

  def can_use?(park)
    return false if !self.claimed?
    return false if self.park_id != park.id
    return false if expired?
    return true
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
