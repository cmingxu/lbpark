class Staff::PagesController < Staff::BaseController

  before_filter do
    @active_nav_item = "pages"
  end
  def index
    @pages = Page.all
  end

  def edit
  end

  def new
  end
end
