# == Schema Information
#
# Table name: sms_codes
#
#  id          :integer          not null, primary key
#  phone       :string(255)
#  params      :text
#  template    :string(255)
#  expire_at   :datetime
#  status      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#  stop        :boolean
#  send_reason :string(255)
#  owner_type  :string(255)
#  owner_id    :integer
#

class SmsCode < ActiveRecord::Base
  belongs_to :user
  belongs_to :owner, :polymorphic => true
  after_create :send_sms

  state_machine :status, :initial => :new_created do
    event :sent do
      transition :new_created => :sent_out
    end

    event :enter do
      transition :sent_out => :entered
    end
  end

  def self.sms_code_valid?(phone, sms_code)
    SmsCode.where(["phone = ? and expire_at > ? ", phone, Time.now]).all.find do |sms|
      sms.params && sms.params == sms_code
    end.present?
  end

  # maximum 3 times for unregistered phone in 30 mins
  def need_set_threshold?
    return false if self.user_id # no need for registered users
    SmsCode.where(["phone = ? and created_at > ?", self.phone, 30.minutes.ago]).count >= 3
  end

  def send_sms
    Resque.enqueue_at Time.now, SendSms, self.id
  end

  def self.new_sms_code(phone)
    new do |s|
      s.phone = phone
      s.params = sprintf("%06d", rand(100000))
      s.send_reason = :vendor_login
      s.expire_at = 10.minutes.from_now
    end
  end

  def self.new_sms_lottery_get(lottery)
    new do |s|
      s.phone = lottery.phone
      s.params = "#{lottery.open_num},#{lottery.serial_num}"
      s.send_reason = :vendor_lottery_get
    end
  end

  def self.new_sms_lottery_miss(user)
    new do |s|
      s.phone = user.phone
      s.params = ""
      s.send_reason = :vendor_lottery_miss
    end
  end
end
