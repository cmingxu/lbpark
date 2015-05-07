class Staff::ParkMapsController < Staff::BaseController
  before_filter :only => :mesh do
    @no_sidebar = true
  end

  def index
  end

  def mesh
    @park = Park.find params[:park_id]
  end

  def create
    @park = Park.find params[:park_id]
    @park_map = @park.park_map || @park.park_map.build
  end
end
