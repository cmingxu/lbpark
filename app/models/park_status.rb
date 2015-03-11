# == Schema Information
#
# Table name: park_statuses
#
#  id         :integer          not null, primary key
#  status     :string(255)
#  park_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  chosen     :boolean
#

class ParkStatus < ActiveRecord::Base
  belongs_to :park
  belongs_to :user
  has_one :lottery

  after_create do
    $redis.setex RedisKey.park_status_key(self.park), Settings.park_status_duration, self.status
  end

  before_save :on => :create do
    if self.class.where(["park_id = ? AND chosen = 1 and created_at > ?", self.park_id, Time.now - Settings.park_status_duration]).count == 0
      self.chosen = true
    end
  end

  def clear_redis_mark
    $redis.del RedisKey.park_status_key(self.park)
  end

  after_create do
    Lottery.spin!(self)
    #if l = Lottery.spin!(self)
      #self.park.messages.create do |m|
        #m.content = "#{self.user.replaced_phone}得到奖票一注"
      #end
      ##SmsCode.new_sms_lottery_get(l)
    #else
      ##SmsCode.new_sms_lottery_miss(self.user)
    #end
  end
end
