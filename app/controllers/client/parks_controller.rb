class Client::ParksController < Client::BaseController
  before_filter do
    @active_nav_item = "parks"
  end

  def index
    @park = current_client.parks.find_by_id params[:id] || current_client.parks.first
  end
end
