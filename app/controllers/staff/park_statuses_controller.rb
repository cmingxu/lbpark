class Staff::ParkStatusesController < Staff::BaseController
  before_filter do
    @active_nav_item = "parks"
  end

  def index
    @park_statuses = ParkStatus.page params[:page]
  end

end
