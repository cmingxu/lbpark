class Dashboard::ParksController < Dashboard::BaseController

  def index
    @parks = Park.page params[:page]
  end
end
