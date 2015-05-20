class Client::ParkSpacesController < Client::BaseController
  before_filter do
    @park = current_client.parks.find params[:park_id] || current_client.parks.first
    @park_map = @park.park_maps.find params[:park_map_id]
  end

  def index
    @park_spaces = @park_map.park_spaces
  end

  def rename
    @park_space = @park_map.park_spaces.find params[:id]
    @park_space.update_column :name, params[:name]
    render :json => @park_map.park_spaces.group_by(&:uuid)
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
end
