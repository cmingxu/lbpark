class Staff::VendorsController < Staff::BaseController
  before_filter do
    @active_nav_item = "vendors"
  end
  def index
    @vendors = User.vendors.order("id DESC").includes :parks
  end

  def new
  end

  def edit
  end
end
