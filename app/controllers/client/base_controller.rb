class Client::BaseController < ApplicationController
  layout "client"
  before_filter :client_login_required
  after_filter :reset_last_captcha_code!

  helper_method :current_client, :current_user

  def current_client
    @current_client ||= Client.find_by_id(session[:client_id])
  end

  def current_user
    current_client
  end

  def index
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
end
