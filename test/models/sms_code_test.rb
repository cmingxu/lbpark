# == Schema Information
#
# Table name: sms_codes
#
#  id         :integer          not null, primary key
#  phone      :string(255)
#  code       :string(255)
#  expire_at  :datetime
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class SmsCodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
