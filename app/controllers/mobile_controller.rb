class MobileController < ApplicationController
  layout "mobile"
  #before_filter :login_required_if_wechat_request, :except => [:login_from_wechat]

  def map
    @current_nav = "map"
  end

  def hot_place
    @current_nav = "search"
  end

  def setting
    @current_nav = "mine"
  end

  def feedback
    @fb = Feedback.new(feedback_params)
    @fb.save
    redirect_to root_path
  end

  def login_from_wechat
    if user = User.login_from_wechat(request.env["omniauth.auth"], :user)
      session[:user_id] = user.id
      redirect_to(session[:redirect_to] || root_path) and return
    end
  end

  def login_required_if_wechat_request
    if current_user.nil?
      redirect_to "/auth/wechat_user" and return
    end
  end

  def feedback_params
    params[:feedback].permit(:content, :contact)
  end
end
