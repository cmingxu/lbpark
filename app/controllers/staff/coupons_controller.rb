class Staff::CouponsController < Staff::BaseController
  before_filter do
    @active_nav_item = "coupons"
  end

  def index
    @coupons = Coupon.order("id DESC").page params[:page]
    if params[:park_id]
      @coupons = Coupon.order("id DESC").where(:park_id => params[:park_id]).page params[:page]
    end

    if params[:type]
      @coupons = Coupon.order("id DESC").where(:coupon_tpl_type => CouponTpl.coupon_class_name(params[:type]).to_s).page params[:page]
    end

    if params[:status]
      @coupons = Coupon.order("id DESC").where(:status => params[:status]).page params[:page]
    end
  end
end
