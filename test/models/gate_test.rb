# == Schema Information
#
# Table name: gates
#
#  id                     :integer          not null, primary key
#  serial_num             :string(255)
#  client_id              :integer
#  park_id                :integer
#  is_in                  :boolean
#  last_heartbeat_seen_at :datetime
#  version                :string(255)
#  hardware_version       :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

require 'test_helper'

class GateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
