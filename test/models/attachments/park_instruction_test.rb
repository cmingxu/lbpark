# == Schema Information
#
# Table name: attachments_park_instructions
#
#  id                :integer          not null, primary key
#  park_instructions :string(255)
#  park_id           :integer
#  original_name     :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'test_helper'

class Attachments::ParkInstructionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
