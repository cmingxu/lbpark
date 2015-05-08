class Staff::ParkMapsController < Staff::BaseController
  before_filter :only => :mesh do
    @no_sidebar = true
  end

  def index
  end

  def mesh
    @park = Park.find params[:park_id]
  end

  def create
    @park = Park.find params[:park_id]
    @park_map = @park.park_map || ParkMap.create(:park => @park)
    @park_map.park_map_eles = []
    params[:objects].values.each do |o|
      @park_map.park_map_eles.create do |ele|
        ele.park_id = @park.id
        ele.park_map_ele_type = o['name']
        ele.ele_desc = o['prop_list']
      end
    end
    head :ok
  end
end
