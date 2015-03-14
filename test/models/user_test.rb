# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  email                :string(255)
#  token                :string(255)
#  encrypted_password   :string(255)
#  phone                :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  role                 :string(255)
#  status               :string(255)
#  openid               :string(255)
#  nickname             :string(255)
#  sex                  :boolean
#  language             :string(255)
#  province             :string(255)
#  city                 :string(255)
#  subscribe_time       :datetime
#  unionid              :string(255)
#  last_login_at        :datetime
#  source               :string(255)
#  headimg              :string(255)
#  scan_coupon          :boolean
#  can_check_high_score :boolean          default(FALSE)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
