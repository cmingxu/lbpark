class MobileCouponsController < MobileController
  before_filter :set_wechat_js_config

  def index
  end

  def coupons_nearby
    @location = Location.new params[:lng], params[:lat]
    @highlighted_coupon_tpls = CouponTpl.highlighted
    @free_coupon_tpls        = CouponTpl::FreeCouponTpl.published.within_range(@location.around(1000))
    @long_term_coupon_tpls   = CouponTpl::LongTermCouponTpl.published.within_range(@location.around(1000))
  end

  def show
    @coupon_tpl = CouponTpl.find params[:id]
  end

  def claim
    @coupon_tpl = CouponTpl.find params[:id]
    if @coupon_tpl.can_be_claimed_by?(current_user)
      if @coupon = @coupon_tpl.claim(current_user)
        @coupon.update_attributes params[:coupon]
        @coupon.claim!
      end
    end
  end
end
