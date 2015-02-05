class Staff::StaffsController < Staff::BaseController
  def index
    @staffs = Staff.page params[:page]
  end

  def new
  end

  def edit
  end
end
