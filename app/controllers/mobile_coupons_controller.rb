class MobileCouponsController < MobileController
  before_filter  :only => [:index, :show, :coupon_show] do
    set_wechat_js_config $wechat_api
  end

  def index
  end

  def coupons_nearby
    @location = Location.new params[:lng], params[:lat]
    @highlighted_coupon_tpls = CouponTpl.highlighted
    @free_coupon_tpls        = CouponTpl::FreeCouponTpl.published.within_range(@location.around(1000))
    @long_term_coupon_tpls   = CouponTpl::LongTermCouponTpl.published.within_range(@location.around(1000))
    render :json => [
      @highlighted_coupon_tpls, @free_coupon_tpls, @long_term_coupon_tpls
    ].flatten.sort_by{|a| a.sort_criteria(@location)}.reverse.map { |ct| ct.as_api_json(@location) }
  end

  def coupons_owned
    @location = Location.new params[:lng], params[:lat]
    render :json => current_user.coupons.map { |ct| ct.as_api_json(@location) }
  end

  def show
    @coupon_tpl = CouponTpl.find params[:id]
  end

  def claim
    @coupon_tpl = CouponTpl.find params[:id]
    if @coupon_tpl.can_be_claimed_by?(current_user)
      if @coupon = @coupon_tpl.claim_coupon
        @coupon.update_attributes coupon_params
        @coupon.claim!
        redirect_to coupon_show_mobile_coupon_path(@coupon)
      end
    end
  end

  def coupon_show
    @coupon = current_user.coupons.find_by_id(params[:id])
  end


  def coupon_params
    params[:coupon] ||= HashWithIndifferentAccess.new
    params[:coupon][:user_id] = current_user.id
    params.require(:coupon).permit(:user_id)
  end

end
