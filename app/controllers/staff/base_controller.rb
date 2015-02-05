class Staff::BaseController < ApplicationController
  layout "staff"
  before_filter :staff_login_required
  after_filter :reset_last_captcha_code!


  helper_method :current_staff, :current_user

  def current_staff
    @current_staff ||= Staff.find_by_id(session[:staff_id])
  end

  def current_user
    current_staff
  end

  def index
  end

  def user_login_in?
    !!current_staff
  end

  def no_login_required
    redirect_to staff_path, :notice => "您已经登陆， 不需要重新登陆" if  user_login_in?
  end

  def store_request_path
    session[:redirect_to] = params[:redirect_to] || request.referer
  end


  def staff_login_required
    unless current_staff
      session[:redirect_to] = request.path
      redirect_to staff_login_path
    end
    false
  end
end
