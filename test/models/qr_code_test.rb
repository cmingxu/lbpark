# == Schema Information
#
# Table name: qr_codes
#
#  id                   :integer          not null, primary key
#  appid                :string(255)
#  which_wechat_account :string(255)
#  status               :string(255)
#  qr_code              :string(255)
#  ticket               :string(255)
#  scene_str            :string(255)
#  mark                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class QrCodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
