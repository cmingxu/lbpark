# == Schema Information
#
# Table name: coupon_tpls
#
#  id         :integer          not null, primary key
#  park_id    :integer
#  staff_id   :integer
#  type       :string(255)
#  identifier :string(255)
#  name_cn    :string(255)
#  end_at     :datetime
#  gcj_lat    :decimal(10, 6)
#  gcj_lng    :decimal(10, 6)
#  quantity   :integer
#  copy_from  :integer
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class CouponTplTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
