# == Schema Information
#
# Table name: wechat_user_activities
#
#  id             :integer          not null, primary key
#  wechat_user_id :integer
#  activity       :string(255)
#  sub_activity   :string(255)
#  params         :text
#  created_at     :datetime
#  updated_at     :datetime


class WechatUserActivity < ActiveRecord::Base
  belongs_to :wechat_user

  def self.log_activity!(request, activity, sub_activity)
    create! do |activity|
      activity.openid = request[:FromUserName]
      activity.activity = activity
      activity.sub_activity = sub_activity
      activity.params = request.message_hash
    end
  end
end
