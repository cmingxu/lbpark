class Staff::ClientsController < Staff::BaseController
  before_filter do
    @active_nav_item = "parks"
    @park = Park.find params[:park_id] || 1
  end

  def index
    @clients = @park.clients.page params[:page]
    @client = @park.clients.build :email => Client.auto_generate_email(@park)
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
    params.require(:client).permit(:email, :password)
  end

end
