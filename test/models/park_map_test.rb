# == Schema Information
#
# Table name: park_maps
#
#  id           :integer          not null, primary key
#  park_id      :integer
#  version      :string(255)
#  last_edit_at :datetime
#  last_edit_by :integer
#  layer        :string(255)
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  name         :string(255)
#

require 'test_helper'

class ParkMapTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
