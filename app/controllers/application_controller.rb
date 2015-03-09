class ApplicationController < ActionController::Base
  # reset captcha code after each request for security
  after_filter :reset_last_captcha_code!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_vendor, :current_user

  def current_vendor
    return nil if session[:vendor_id].nil?
    User.vendors.find_by_id(session[:vendor_id])
  end


  def current_park
    current_vendor.park
  end


  def current_user
    return nil if session[:user_id].nil?
    User.find_by_id(session[:user_id])
  end

  def store_request_path
    session[:redirect_to] = params[:redirect_to] || request.referer
  end

  def wechat_browser_required
    if Rails.env.production?
      redirect_to root_path unless user_agent_wechat?
      false
    else
      true
    end
  end

  def user_agent_wechat?
    !!(request.user_agent =~ /MicroMessenger/i)
  end
end
