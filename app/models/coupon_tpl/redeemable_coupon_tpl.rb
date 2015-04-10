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
