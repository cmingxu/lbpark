class Staff::SessionController < Staff::BaseController
  skip_before_filter :staff_login_required
  before_filter :validate_captcha, :only => [:login, :register, :forget_password, :reset_password], :if => lambda { !request.get? }

  layout "session"

  def login
    store_request_path

    if request.post?
      if @staff = Staff.login(user_params[:email], user_params[:password])
        session[:staff_id] = @staff.id
        redirect_to staff_path, notice: "欢迎回来，#{@staff.email}"
      else
        redirect_to staff_login_path, alert: "用户名密码不正确， 或者您尚未激活账号."
      end
    end
  end

  def destroy
    session[:staff_id] = nil
    redirect_to staff_login_path, alert: "bye"
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
