class Staff::CouponsController < Staff::BaseController
  before_filter do
    @active_nav_item = "coupons"
  end

  def index
    @coupons = Coupon.order("id DESC").page params[:page]
  end
end
