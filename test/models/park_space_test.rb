# == Schema Information
#
# Table name: park_spaces
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  uuid            :string(255)
#  park_map_id     :integer
#  park_id         :integer
#  park_map_ele_id :integer
#  usage_status    :string(255)
#  vacancy_status  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class ParkSpaceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
