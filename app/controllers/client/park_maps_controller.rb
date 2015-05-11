class Client::ParkMapsController < Client::BaseController
  def index
    @park = current_client.park
    @park_maps = @park.park_maps
    @park_map = current_client.park.park_maps.find_by_id params[:park_map_id] || current_client.park.park_maps.first
  end
end
