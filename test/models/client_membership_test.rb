# == Schema Information
#
# Table name: client_memberships
#
#  id               :integer          not null, primary key
#  client_member_id :integer
#  order_id         :integer
#  begin_at         :datetime
#  end_at           :datetime
#  month_count      :integer
#  total_price      :integer
#  created_at       :datetime
#  updated_at       :datetime
#  park_space_id    :integer
#

require 'test_helper'

class ClientMembershipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
