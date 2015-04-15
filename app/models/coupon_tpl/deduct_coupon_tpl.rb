class CouponTpl::DeductCouponTpl < CouponTpl

  def type_name_in_zh
    "满#{self.lower_limit_for_deduct}减#{self.coupon_value}"
  end
end
