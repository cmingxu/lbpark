# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  order_num  :string(255)
#  park_id    :integer
#  user_id    :integer
#  status     :string(255)
#  price      :integer
#  coupon_id  :integer
#  paid_at    :datetime
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
