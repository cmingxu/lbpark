class MobileController < ApplicationController
  layout "mobile"
  before_filter do
    @current_nav = "home"
  end
  
  def map
  end
end
