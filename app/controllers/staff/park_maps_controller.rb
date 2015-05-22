class Staff::ParkMapsController < Staff::BaseController
  before_filter :only => :mesh do
    @no_sidebar = true
  end

  def index
    @park = Park.find params[:park_id]
    @park_map =  @park.park_maps.find_by_id(params[:park_map_id]) || @park.park_maps.first || ParkMap.create(:park => @park, :name => "地面")
    @park_maps = @park.park_maps

    if params[:fullscreen]
      render "fullscreen", :layout => "staff_no_sidebar"
    end
  end

  def new
    @park = Park.find params[:park_id]
    @park.park_maps.create :name => "地面 #{@park.park_maps.length}"
    if params[:copy_from_id]
      recently_created_park_map = @park.park_maps.last
      copy_from = @park.park_maps.find params[:copy_from_id]
      copy_from.park_map_eles.each do |ele|
        recently_created_park_map.park_map_eles.create  :park_id => ele.park_id, :park_map_ele_type => ele.park_map_ele_type, :ele_desc => ele.ele_desc, :uuid => ele.uuid
      end
    end
    redirect_to staff_park_park_maps_path(@park, :park_map_id => @park.park_maps.last.id)
  end

  def rename
    @park = Park.find params[:park_id]
    @park_map = @park.park_maps.find params[:park_map_id]
    @park_map.update_column :name, params[:new_name] if params[:new_name].present?
    head :ok
  end

  def destroy
    @park = Park.find params[:park_id]
    @park_map = @park.park_maps.find params[:id]
    @park_map.destroy
    redirect_to staff_park_park_maps_path(@park)
  end


  def create
    @park = Park.find params[:park_id]
    @park_map = @park.park_maps.find params[:park_map_id]
    if params[:objects]
      eles = @park_map.park_map_eles - @park_map.park_map_eles.where(["uuid in (?)", params[:objects].values.map{|o| o["uuid"]}])
      eles.map(&:destroy)
    end
    params[:objects].values.each do |o|
      pme = @park_map.park_map_eles.find_or_create_by(:uuid => o["uuid"])
      pme.tap do |ele|
        ele.park_id = @park.id
        ele.park_map_ele_type = o['name']
        ele.ele_desc = o['prop_list']
        ele.uuid = o["uuid"]
      end.save
    end
    head :ok
  end
end
