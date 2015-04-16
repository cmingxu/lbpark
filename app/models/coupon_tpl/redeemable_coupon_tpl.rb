# == Schema Information
#
# Table name: coupon_tpls
#
#  id                     :integer          not null, primary key
#  park_id                :integer
#  priority               :integer
#  staff_id               :integer
#  type                   :string(255)
#  identifier             :string(255)
#  name_cn                :string(255)
#  fit_for_date           :date
#  end_at                 :datetime
#  gcj_lat                :decimal(10, 6)
#  gcj_lng                :decimal(10, 6)
#  quantity               :integer
#  price                  :integer
#  copy_from              :integer
#  status                 :string(255)
#  published_at           :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  banner                 :string(255)
#  notice                 :string(255)
#  coupon_value           :integer
#  valid_hour_begin       :integer
#  valid_hour_end         :integer
#  lower_limit_for_deduct :integer
#  valid_dates            :string(255)
#

class CouponTpl::RedeemableCouponTpl < CouponTpl
  validates :coupon_value, presence: true
  validates :price, presence: true

  def redeemable?
    true
  end

  def type_name_in_zh
    "代金"
  end
end
