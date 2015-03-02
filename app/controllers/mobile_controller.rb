class MobileController < ApplicationController
  layout "mobile"
  def map
    @current_nav = "map"
  end

  def hot_place
    @current_nav = "search"
  end

  def setting
    @current_nav = "mine"
  end
end
