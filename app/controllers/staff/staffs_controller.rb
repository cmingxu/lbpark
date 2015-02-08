class Staff::StaffsController < Staff::BaseController
  def index
    @staffs = Staff.page params[:page]
  end

  def new
  end

  def edit
  end

  def i_want_change_pass
  end

  def change_password
    current_staff.password=  params[:new_pass]
    current_staff.save
    session[:staff_id] = nil
    redirect_to staff_parks_path
  end
end
