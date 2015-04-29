class Client::ParkMapsController < Client::BaseController
  before_filter :only => :mesh do
    @no_sidebar = true
  end
  def index
  end

  def mesh
  end
end
