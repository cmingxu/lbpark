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

  def login_from_wechat
    if user = User.login_from_wechat(request.env["omniauth.auth"], :user)
      session[:vendor_id] = user.id
      redirect_to(session[:redirect_to] || vendor_index_path) and return
    end
  end
end
