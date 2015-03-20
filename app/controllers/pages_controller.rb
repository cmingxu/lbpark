class PagesController < MobileController
  layout "mobile_no_tab"

  def show
    @page = Page.find_by_permalink(params[:id])
  end
end
