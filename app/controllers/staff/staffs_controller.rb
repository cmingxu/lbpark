class Staff::StaffsController < Staff::BaseController
  before_filter do
    @active_nav_item = "staffs" 
  end

  def index
    @staffs = Staff.page params[:page]
  end

  def new
  end

  def edit
  end

  def i_want_change_pass
    @active_nav_item = "setting"
  end

  def change_password
    current_staff.password=  params[:new_pass]
    current_staff.save
    session[:staff_id] = nil
    redirect_to staff_parks_path
  end
end
