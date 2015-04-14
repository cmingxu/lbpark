class Client::ParksController < Client::BaseController
  before_filter do
    @active_nav_item = "parks"
  end

  def index
    @park = current_client.park
  end
end
