# == Schema Information
#
# Table name: client_members
#
#  id                 :integer          not null, primary key
#  client_id          :integer
#  member_id          :integer
#  client_user_id     :integer
#  source             :string(255)
#  name               :string(255)
#  phone              :string(255)
#  paizhao            :string(255)
#  driver_license_pic :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class ClientMemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
