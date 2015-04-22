class MobileController < ApplicationController
  layout "mobile"
  before_filter :login_required, :except => [:login_from_wechat]
  before_filter  :only => [:map, :hot_place, :setting] do
    set_wechat_js_config $wechat_api
  end

  def js_log
    log("JSLOG", params[:what], params.except(*[:controller, :action, :what]))
    head :ok
  end

  def map
    @current_nav = "map"
    if params[:name]
      log("RUBY_LOG", "MAP_SEARCH", :name => URI.decode(params[:name]))
    else
      log("RUBY_LOG", "MAP_VIEW", params.except(*[:controller, :action, :what]))
    end
  end

  def hot_place
    @current_nav = "search"
    render :layout => "mobile_no_tab_with_amap"
  end

  def setting
    @current_nav = "mine"
    log("RUBY_LOG", "SETTING_VIEW", {})
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
      log("RUBY_LOG", "LOGIN_FROM_WECHAT", {})
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

  def log(source, what, p)
    return unless current_user
    ACTIVITY_LOGGER.info "#{source} #{what} #{Time.now.to_i} #{current_user.id} #{current_user.openid} #{request.headers["X-Real-IP"]} #{p.to_query}"
  end

end
