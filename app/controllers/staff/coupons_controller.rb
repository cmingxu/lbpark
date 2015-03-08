class Staff::CouponsController < Staff::BaseController
  before_filter do
    @active_nav_item = "coupons"
  end

  def index
    @coupons = Coupon.page params[:page]
  end
end
