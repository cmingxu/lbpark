class Staff::ParksController < Staff::BaseController
  before_filter do
    @active_nav_item = "parks"
  end

  def index
    respond_to do |format|
      format.html do
        if params[:district]
          @parks = Park.where(["district like ?", "%#{params[:district]}%"]).page params[:page]
        elsif params[:park_type]
          @parks = Park.where(["park_type = ?", params[:park_type]]).page params[:page]
        elsif params[:park_type_code]
          @parks = Park.where(["park_type_code = ?", params[:park_type_code]]).page params[:page]
        else
          @parks = Park.page params[:page]
        end
      end

      format.json do
        @parks = Park.where(["name like ?", "%#{params[:match]}%"])
        if params[:type_a_only]
          @parks = @parks.with_park_type_code('A')
        end
        render :json => @parks
      end
    end
  end

  def new
    @park = Park.new
  end

  def edit
    @park = Park.find(params[:id])
  end

  def create
    @park = Park.new park_params
    if @park.save
      alert = "车录入成功"
      redirect_to edit_staff_park_path(@park), :alert => alert
    else
      notice = "车场录入失败" + @park.errors.full_messages.first
      render :new, :notice => notice
    end
  end

  def update
    @park = Park.find(params[:id])
    if @park.update_attributes(park_params)
      alert = "车场更新成功"
    else
      notice = "车场更新失败" + @park.errors.full_messages.first
    end

    redirect_to edit_staff_park_path(@park), :alert => alert, :notice => notice
  end

  def park_params
    permitted_params = Park::COLUMN_MAP.keys
    permitted_params << { :park_instructions_attributes => [:id, :park_instructions, :_destroy] }
    permitted_params <<  { :park_pics_attributes => [:id, :park_pic, :_destroy] }
    params.require(:park).permit(permitted_params)
  end
end
