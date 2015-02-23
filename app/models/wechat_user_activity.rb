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
#

class WechatUserActivity < ActiveRecord::Base
end
