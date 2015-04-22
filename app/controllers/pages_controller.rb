class PagesController < MobileController
  layout "mobile_no_tab"

  def show
    @page = Page.find_by_permalink(params[:id])
    log("RUBY_LOG", "PAGE_VIEW", :page => params[:id])
  end
end
