# == Schema Information
#
# Table name: coupons
#
#  id                :integer          not null, primary key
#  park_id           :integer
#  coupon_tpl_id     :integer
#  identifier        :string(255)
#  user_id           :integer
#  status            :string(255)
#  end_at            :datetime
#  price             :integer
#  issued_address    :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  claimed_at        :datetime
#  fit_for_date      :date
#  coupon_tpl_type   :string(255)
#  expire_at         :datetime
#  qr_code           :string(255)
#  issued_begin_date :date
#  used_at           :datetime
#

require 'test_helper'

class CouponTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
