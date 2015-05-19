class Client::BaseController < ApplicationController
  layout "client"

  before_filter :client_login_required
  before_filter :mobile_registered_and_verifed, :except => [:setup, :set_phone, :sms_verify, :sms_send, :send_sms_code]
  before_filter :make_sure_password_changed, :except => [:setup, :do_password_change, :set_phone, :sms_verify, :sms_send, :send_sms_code]
  after_filter :reset_last_captcha_code!

  helper_method :current_client, :current_user, :current_client_user

  def current_client
    @current_client ||= current_client_user.client
  end

  def current_client_user
    @current_client_user ||= ClientUser.find_by_id(session[:client_user_id])
  end

  def current_user
    current_client_user
  end

  def index
    @active_nav_item = "clients"
  end

  def user_login_in?
    !!current_client_user
  end

  def no_login_required
    redirect_to client_path, :notice => "您已经登陆， 不需要重新登陆" if  user_login_in?
  end

  def store_request_path
    session[:redirect_to] = params[:redirect_to] || request.referer
  end

  def client_login_required
    unless current_client_user
      session[:redirect_to] = request.path
      redirect_to client_login_path
    end
    false
  end

  def mobile_registered_and_verifed
    if !current_client_user.phone_verified?
      redirect_to client_setup_path and return false
    end
  end

  def make_sure_password_changed
    if !current_client_user.password_changed?
      redirect_to client_setup_path and return false
    end
  end

  def setup
  end

  def set_phone
    current_client_user.phone = params[:phone]
    if current_client_user.save
      SmsCode.new_sms_code(current_client_user.phone).save
      redirect_to client_setup_path, :notice => "设置成功"
    else
      redirect_to client_setup_path, :alert => "电话号码不正确"
    end
  end

  def sms_verify
    redirect_to(client_setup_path, :alert => "验证码不能空") and return if params[:sms_code].blank?

    if SmsCode.sms_code_valid? current_client_user.phone, params[:sms_code]
      current_client_user.phone_verified = true
      current_client_user.save
      redirect_to client_setup_path, :notice => "验证码正确"
    else
      redirect_to client_setup_path, :alert => "验证码不正确"
    end
  end

  def do_password_change
    redirect_to(client_setup_path, :alert => "密码不能空") and return if params[:password].blank?
    redirect_to(client_setup_path, :alert => "密码验证不能空") and return if params[:password_confirmation].blank?
    redirect_to(client_setup_path, :alert => "两次密码不匹配") and return if params[:password] != params[:password_confirmation]

    current_client_user.password = params[:password]
    current_client_user.password_changed = true
    current_client_user.save
    redirect_to client_path, :notice => "修改成功"
  end

  def send_sms_code
    SmsCode.new_sms_code(current_client_user.phone).save
    head :ok
  end

end
