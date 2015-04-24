class VendorCouponsController < VendorController

  before_filter :current_vendor_required, :only => [:index, :use]
  before_filter :mobile_bind_required, :only => [:index, :use]
  before_filter :vendor_park_required, :only => [:index, :use]

  def index
  end

  def use
    @coupon = current_park.coupons.claimed.long_term_or_fit_for_today.find_by_identifier params[:id]
    if @coupon && @coupon.can_use?(current_vendor.park)
      @coupon.use!
      @scan_result = true
      @scan_msg    = "扫码成功"
    else
      @scan_result = false
      @scan_msg    = "扫码失败"
    end
  end
end
