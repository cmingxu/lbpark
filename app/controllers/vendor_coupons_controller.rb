class VendorCouponsController < VendorController
  def index
  end

  def use
    @coupon = current_park.coupons.find_by_identifier params[:id]
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
