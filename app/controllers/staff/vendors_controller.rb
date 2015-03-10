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

  def rentention
    ps = ParkStatus.select([:user_id, :created_at]).where(["created_at > ?", 30.day.ago])
    ps = ps.group_by{|p| p.created_at.strftime("%Y-%m-%d") }
    @data = ps.map {|k, v| [k, v.map(&:user_id).uniq]}
    @registration_data = User.select("id, created_at")
    @registration_data = @registration_data.group_by{|p| p.created_at.strftime("%Y-%m-%d") }
    @registration_data = @registration_data.map {|k, v| [k, v.map(&:id).uniq]}
  end

  def by_day
    ps = ParkStatus.select([:id, :created_at])
    ps = ps.group_by{|p| p.created_at.strftime("%Y-%m-%d") }
    @data = ps.map {|k, v| [k, v.length]}
  end

  def by_hour
    date = begin Time.parse(params[:date]) rescue Time.now end
    ps = ParkStatus.select([:id, :created_at]).where(["? < created_at && created_at < ?", date.beginning_of_day, date.end_of_day])
    ps = ps.group_by{|p| p.created_at.strftime("%H") }
    @data = ps.map {|k, v| [k, v.length]}
  end

  def  by_vendor
    ps = ParkStatus.select([:id, :user_id])
    ps = ps.group_by{|p| p.user_id }
    @data = ps.map {|k, v| [k, v.length]}.map{|k, v| u = User.find_by_id(k); ["#{u.try(:nickname)}(#{u.try(:park).try(:name)})",v]}.sort{|i| i[1]}
  end
end
