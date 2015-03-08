class MobileCouponsController < MobileController

  def index
    @highlighted_coupon_tpls = CouponTpl.highlighted
    @free_coupon_tps         = CouponTpl::FreeCouponTpl.published.where()
  end
end
