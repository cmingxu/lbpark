class Staff::ParkImportsController < Staff::BaseController
  before_filter :find_import
  before_filter do
    @active_nav_item = "imports"
  end

  def index
    @park_imports = @import.park_imports
  end

  def new
  end

  def find_import
    @import = Import.find params[:import_id]
  end

end
