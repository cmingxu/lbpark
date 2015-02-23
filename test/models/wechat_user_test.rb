# == Schema Information
#
# Table name: wechat_users
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  status         :string(255)
#  openid         :string(255)
#  nickname       :string(255)
#  sex            :integer
#  language       :string(255)
#  province       :string(255)
#  country        :string(255)
#  headimg        :string(255)
#  subscribe_time :datetime
#  unionid        :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class WechatUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
