class CouponTpl::TimeCouponTpl < CouponTpl
  validates :coupon_value, presence: true
  validates :price, presence: true

  def redeemable?
    true
  end

  def type_name_in_zh
    "次"
  end
end
