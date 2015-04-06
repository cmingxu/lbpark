class Client::SessionController < Client::BaseController
  skip_before_filter :client_login_required
  before_filter :validate_captcha, :only => [:login, :register, :forget_password, :reset_password], :if => lambda { !request.get? }

  layout "client_session"

  def login
    store_request_path

    if request.post?
      if @client = Client.login(user_params[:email], user_params[:password])
        session[:client_id] = @client.id
        redirect_to client_path, notice: "欢迎回来，#{@client.email}"
      else
        redirect_to client_login_path, alert: "用户名密码不正确， 或者您尚未激活账号."
      end
    end
  end

  def destroy
    session[:client_id] = nil
    redirect_to client_login_path, alert: "bye"
  end

  def validate_captcha
    return true if request.get?

    if !valid_captcha?(user_params[:captcha])
      redirect_to :back, alert: "您输入的验证码有误" and return false
    end
  end

  def user_params
    params[:user].permit(:email, :password, :password_confirmation, :captcha, :reset_password_token)
  end
end
