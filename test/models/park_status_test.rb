# == Schema Information
#
# Table name: park_statuses
#
#  id         :integer          not null, primary key
#  status     :string(255)
#  park_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ParkStatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
