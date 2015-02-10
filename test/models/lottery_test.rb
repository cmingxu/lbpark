# == Schema Information
#
# Table name: lotteries
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  open_num       :string(255)
#  serial_num     :string(255)
#  park_status_id :integer
#  park_id        :integer
#  phone          :string(255)
#  open_at        :datetime
#  notes          :text
#  win            :boolean
#  win_amount     :integer
#  status         :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class LotteryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
