class Staff::ClientsController < Staff::BaseController
  before_filter do
    @active_nav_item = "clients"
    @park = Park.find params[:park_id] || 1
  end

  def index
    @clients = @park.clients.page params[:page]
    @client = @park.clients.build :login => Client.auto_generate_login(@park)
  end

  def destroy
    @client = @park.clients.find params[:id]
    @client.destroy
    redirect_to staff_park_clients_path(@park)
  end

  def create
    @client = @park.clients.build client_params
    @client.save
    redirect_to staff_park_clients_path(@park)
  end

  def client_params
    params.require(:client).permit(:login, :password)
  end

end
