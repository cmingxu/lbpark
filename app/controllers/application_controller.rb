class ApplicationController < ActionController::Base
  # reset captcha code after each request for security
  after_filter :reset_last_captcha_code!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_vendor

  def current_vendor
    return nil if session[:vendor_id].nil?
    User.vendors.find_by_id(session[:vendor_id])
  end

  def store_request_path
    session[:redirect_to] = params[:redirect_to] || request.referer
  end
end
