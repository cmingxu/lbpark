class Client::ClientMembersController < Client::BaseController
  before_filter do
    @active_nav_item = "client_members"
  end

  def index
    @client_members = current_client.client_members
  end

  def new
    @park_space = ParkSpace.find_by_id(params[:park_space_id])
    @client_member = current_client.client_members.build
    @client_member.client_memberships.build :park_space_id => params[:park_space_id]
    render :layout => false
  end

  def edit
    @client_member = current_client.client_members.find params[:id]
    @client_member.client_memberships.build
    render :layout => false
  end

  def update
    @client_member = current_client.client_members.find params[:id]
    @client_member.update_attributes client_member_params
    if @client_member.save
      redirect_to client_client_members_path, :alert => "成功"
    else
      redirect_to client_client_members_path, :notice => @client_member.errors.full_messages.first
    end
  end

  def create
    @client_member = current_client.client_members.build client_member_params
    if @client_member.save
      redirect_to client_client_members_path, :alert => "成功"
    else
      redirect_to client_client_members_path, :notice => @client_member.errors.full_messages.first
    end
  end

  def client_member_params
    params.require(:client_member).permit(:name, :phone, :paizhao, :client_memberships_attributes => [ :begin_at, :month_count, :total_price, :id, :park_space_id ])
  end
end
