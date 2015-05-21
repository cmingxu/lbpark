class Client::ParkSpacesController < Client::BaseController
  before_filter :find_instance_var, :except => [:park_space_json]

  def park_space_json
    @park = current_client.parks.find_by_id(params[:park_id]) || current_client.parks.first
    @park_spaces = @park.park_spaces

    respond_to do |format|
      format.html
      format.json do
        render :json => @park_spaces
      end
    end
  end

  def index
    @park_spaces = @park_map.park_spaces
  end

  def rename
    @park_space = @park_map.park_spaces.find params[:id]
    @park_space.update_column :name, params[:name]
    render :json => @park_map.park_spaces.group_by(&:uuid)
  end

  def client_member
    @park_space = @park_map.park_spaces.find params[:id]
    @active_client_membership = @park_space.active_client_membership
    @client_member = @active_client_membership.try(:client_member)
    render :json => {
      :name => @client_member.try(:name),
      :phone => @client_member.try(:phone),
      :paizhao => @client_member.try(:paizhao),
      :end_at => @active_client_membership.try(:end_at),
      :month_count => @active_client_membership.try(:month_count),
      :total_price => @active_client_membership.try(:total_price)
    }
  end

  def change_usage_status
    @park_space = @park_map.park_spaces.find params[:id]
    @park_space.update_column :usage_status, params[:status]
    render :json => @park_map.park_spaces.group_by(&:uuid)
  end

  def change_vacancy_status
    @park_space = @park_map.park_spaces.find params[:id]
    @park_space.update_column :vacancy_status, params[:status]
    render :json => @park_map.park_spaces.group_by(&:uuid)
  end

  def find_instance_var
    @park = current_client.parks.find params[:park_id] || current_client.parks.first
    @park_map = @park.park_maps.find params[:park_map_id]
  end
end
