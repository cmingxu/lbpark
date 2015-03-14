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
#  openid         :string(255)
#

require 'test_helper'

class WechatUserActivityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
