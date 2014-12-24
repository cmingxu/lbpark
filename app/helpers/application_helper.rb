module ApplicationHelper
  def map_nav_class(nav)
    @current_nav == nav ? nav + "_press" : nav
  end
end
