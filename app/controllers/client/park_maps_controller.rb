class Client::ParkMapsController < Client::BaseController
  required_plugin :park_map

  before_filter do
    @active_nav_item = "park_maps"
  end

  def index
    @park = current_client.parks.find_by_id(params[:id]) || current_client.parks.first
    @park_maps = @park.park_maps
    @park_map = @park.park_maps.find_by_id params[:park_map_id] || @park.park_maps.first
  end

  def list
    @park = current_client.parks.find_by_id(params[:id]) || current_client.parks.first
    @park_maps = @park.park_maps
    @park_map = @park.park_maps.find_by_id params[:park_map_id] || @park.park_maps.first
    @park_spaces = @park_map.park_spaces.page params[:page]
  end
end
