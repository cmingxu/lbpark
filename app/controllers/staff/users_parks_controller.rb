class Staff::UsersParksController < Staff::BaseController
  before_filter do
    @active_nav_item = "vendors"
    @vendor = User.vendors.find params[:user_id]
  end


  def new
    @users_park = @vendor.users_parks.build
  end

  def create
    @users_park = @vendor.users_parks.new users_park_param
    @users_park.save
    redirect_to staff_vendors_path
  end

  def users_park_param
    params[:users_park].permit(:user_id, :park_id)
  end
end
