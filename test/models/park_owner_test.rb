# == Schema Information
#
# Table name: park_owners
#
#  id             :integer          not null, primary key
#  park_id        :integer
#  wgs_lat        :decimal(10, 6)
#  wgs_lng        :decimal(10, 6)
#  contract       :string(255)
#  contract_phone :string(255)
#  ownership      :string(255)
#  owner          :string(255)
#  desc           :text
#  maintainer     :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class ParkOwnerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
