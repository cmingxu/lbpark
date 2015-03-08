class VendorCouponsController < VendorController
  def index
  end

  def use
    @coupon = current_park.coupons.find_by_id params[:id]
    if @coupon
      @coupon.use!
    end
  end
end
