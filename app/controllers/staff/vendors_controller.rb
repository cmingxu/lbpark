class Staff::VendorsController < Staff::BaseController
  before_filter do
    @active_nav_item = "vendors"
  end
  def index
    scope =  User.vendors.order("id DESC").includes(:parks)

    @vendors = scope
  end

  def new
  end

  def edit
  end

  def switch_scan_coupon_status
    @vendor = User.find params[:vendor_id]
    @vendor.scan_coupon = !@vendor.scan_coupon
    @vendor.save
    redirect_to :back
  end
end
