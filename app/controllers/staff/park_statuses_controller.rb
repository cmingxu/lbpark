class Staff::ParkStatusesController < Staff::BaseController
  before_filter do
    @active_nav_item = "parks"
  end

  def index
    @park_statuses = ParkStatus.order('id desc').page params[:page]
  end

end
