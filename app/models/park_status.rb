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
#

class ParkStatus < ActiveRecord::Base
  belongs_to :park
  belongs_to :user

  after_create do
    $redis.setex RedisKey.park_status_key(self.park), Settings.park_status_duration, self.status
  end
end
