# == Schema Information
#
# Table name: coupon_scans
#
#  id            :integer          not null, primary key
#  coupon_id     :integer
#  coupon_tpl_id :integer
#  scan_by_id    :integer
#  gcj_lat       :decimal(10, 6)
#  gcj_lng       :decimal(10, 6)
#  park_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class CouponScanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
