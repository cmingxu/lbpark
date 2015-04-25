class WelcomeController < ApplicationController
  def index
  end

  def heatmap
    render :layout => "for_public"
  end
end
