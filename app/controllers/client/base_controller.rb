class Client::BaseController < ApplicationController
  layout "client"

  before_filter :client_login_required
  before_filter :mobile_registered_and_verifed, :except => [:setup, :set_phone, :sms_verify, :sms_send]
  before_filter :make_sure_password_changed, :except => [:setup, :do_password_change, :set_phone, :sms_verify, :sms_send]
  after_filter :reset_last_captcha_code!

  helper_method :current_client, :current_user

  def current_client
    @current_client ||= Client.find_by_id(session[:client_id])
  end

  def current_user
    current_client
  end

  def index
    @active_nav_item = "clients"
  end

  def user_login_in?
    !!current_client
  end

  def no_login_required
    redirect_to client_path, :notice => "您已经登陆， 不需要重新登陆" if  user_login_in?
  end

  def store_request_path
    session[:redirect_to] = params[:redirect_to] || request.referer
  end

  def client_login_required
    unless current_client
      session[:redirect_to] = request.path
      redirect_to client_login_path
    end
    false
  end

  def mobile_registered_and_verifed
    if !current_client.phone_verified?
      redirect_to client_setup_path and return false
    end
  end

  def make_sure_password_changed
    if !current_client.password_changed?
      redirect_to client_setup_path and return false
    end
  end

  def setup
  end

  def set_phone
    current_client.phone = params[:phone]
    if current_client.save
      redirect_to client_setup_path, :notice => "设置成功"
    else
      redirect_to client_setup_path, :alert => "电话号码不正确"
    end
  end

  def sms_verify
  end

  def do_password_change
  end

end
