class Staff::PagesController < Staff::BaseController

  before_filter do
    @active_nav_item = "pages"
  end

  def index
    @pages = Page.all
  end

  def edit
    @page = Page.find params[:id]
  end

  def create
    @page = Page.new params.require(:page).permit :title, :permalink, :content
    if @page.save
      redirect_to staff_pages_path, :notice => "Page创建成功"
    else
      redirect_to staff_pages_path, :alert => "创建失败 #{@page.errors.full_messages}"
    end
  end

  def update
    @page = Page.find params[:id]
    if @page.update_attributes params.require(:page).permit(:title, :permalink, :content)
      redirect_to staff_pages_path, :notice => "Page创建成功"
    else
      render :new, :alert => "创建失败 #{@page.errors.full_messages}"
    end
  end

  def new
    @page = Page.new :content =>"new"
  end
end
