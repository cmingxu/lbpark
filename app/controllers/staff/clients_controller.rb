class Staff::ClientsController < Staff::BaseController
  before_filter do
    @active_nav_item = "clients"
    @park = Park.find params[:park_id] || 1
  end

  def index
    respond_to do |format| 
      format.html do 
        if @park.client.blank?
          @park.client = Client.create
          @park.save
        end

        @client = @park.client
        @client_users = @client.client_users
        @client_user = @client.client_users.build :login => ClientUser.auto_generate_login(@park)
      end
      format.json do
        @clients = Client.where(["name like ? OR address like ? OR contact like ?", "%#{params[:match]}%","%#{params[:match]}%" ,"%#{params[:match]}%"  ])
        render :json => @clients
      end
    end


  end

  def destroy
    @client = @park.client
    @client_user = @park.client_users.find params[:id]
    @client_user.destroy
    redirect_to staff_park_clients_path(@park)
  end

  def create
    @client = @park.client
    @client_user = @client.client_users.build client_user_params
    @client_user.save
    redirect_to staff_park_clients_path(@park)
  end

  def client_user_params
    params.require(:client_user).permit(:login, :password)
  end

  def client_params
    params.require(:client).permit(:name, :contact, :address)
  end

  def update_client
    @client = @park.client
    @client.update_attributes client_params
    @client.save

    redirect_to staff_park_clients_path @park
  end

end
