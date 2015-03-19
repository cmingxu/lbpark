class MobileController < ApplicationController
  layout "mobile"
  before_filter :login_required, :except => [:login_from_wechat]
  before_filter  :only => [:map, :hot_place, :setting] do
    set_wechat_js_config $wechat_api
  end

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
    if request.post?
      @fb = Feedback.new(feedback_params)
      @fb.save
      redirect_to map_path and return

    end
    render :feedback, :layout => "mobile_no_tab"
  end

  def login_from_wechat
    if user = User.login_from_wechat(request.env["omniauth.auth"], :user)
      session[:user_id] = user.id
      redirect_to(session[:user_redirect_to] || map_path) and return
    end
  end

  def login_required
    if !Rails.env.production?
      session[:user_id] = User.first.id
      return true
    end

    if current_user.nil?
      session[:user_redirect_to] = request.path if !request.post?
      redirect_to "/auth/wechat_user" and return
      return false
    end
  end

  def feedback_params
    params[:feedback].permit(:content, :contact)
  end

end
