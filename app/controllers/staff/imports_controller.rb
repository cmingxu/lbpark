class Staff::ImportsController < Staff::BaseController
  before_filter do
    @active_nav_item = "imports"
  end

  def index
    @imports = Import.page params[:page]
  end

  def new
    @import = current_staff.imports.build
    @import.park_type  = 'A'
  end

  def create
    @import = current_staff.imports.build import_param
    if @import.save
      redirect_to staff_import_park_imports_path(@import)
    else
      render :new
    end
  end

  def import_param
    params.require(:import).permit :note, :imported_csv, :park_type
  end


  def merge
    @import = Import.find params[:import_id]
    @import.merge
    redirect_to staff_imports_path, :notice => "上传成功"
  end



  def destroy
    @import = Import.find(params[:id])
    @import.destroy
    redirect_to staff_imports_path, :notice => "删除成功"
  end
end
