class CouponTpl::TimeCouponTpl < CouponTpl
  def redeemable?
    true
  end

  def type_name_in_zh
    "次"
  end
end
