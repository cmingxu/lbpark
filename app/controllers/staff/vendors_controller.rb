class Staff::VendorsController < Staff::BaseController
  def index
    @vendors = User.vendors.includes :parks
  end

  def new
  end

  def edit
  end
end
