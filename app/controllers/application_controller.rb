class ApplicationController < ActionController::Base
  # reset captcha code after each request for security
  after_filter :reset_last_captcha_code!

  before_filter do
    Rails.logger.debug request.remote_ip
    Rails.logger.debug request.ip
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_vendor, :current_user

  def current_vendor
    return nil if session[:vendor_id].nil?
    User.vendors.find_by_id(session[:vendor_id])
  end

  def current_client
    return nil if session[:client_id].nil?
    @client ||= Client.find session[:client_id]
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
    return true
    #!!(request.user_agent =~ /MicroMessenger/i)
  end

  def set_wechat_js_config(wechat_api)
    @config = {
      :jsapi_ticket => wechat_api.js_ticket,
      :noncestr  => SecureRandom.hex(10),
      :timestamp => Time.now.to_i,
      :url => request.url
    }
    @config[:signature] = Digest::SHA1.hexdigest(@config.keys.sort.map{|k| "#{k}=#{@config[k]}" }.join("&"))
  end

  def sms_code_valid?
    sms_code = SmsCode.find_by_id(params[:sms_code_id])
    return false unless sms_code
    sms_code.params == params[:sms_code]
  end

end
