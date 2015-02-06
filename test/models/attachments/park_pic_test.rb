# == Schema Information
#
# Table name: attachments_park_pics
#
#  id            :integer          not null, primary key
#  park_pic      :string(255)
#  park_id       :integer
#  original_name :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class Attachments::ParkPicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
