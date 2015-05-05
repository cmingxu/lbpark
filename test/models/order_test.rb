# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  order_num        :string(255)
#  park_id          :integer
#  user_id          :integer
#  status           :string(255)
#  price            :integer
#  coupon_id        :integer
#  paid_at          :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  body             :string(255)
#  spbill_create_ip :string(255)
#  notify_url       :string(255)
#  bank_type        :string(255)
#  transaction_id   :string(255)
#  ip               :string(255)
#  prepay_id        :string(255)
#  quantity         :integer
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
