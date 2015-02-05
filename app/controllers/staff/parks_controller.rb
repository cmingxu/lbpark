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
        render :json => @parks
      end
    end
  end

  def new
  end

  def edit
    @park = Park.find(params[:id])
  end
end
