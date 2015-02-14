class VendorController < ApplicationController
  layout "vendor"
  skip_before_filter :verify_authenticity_token
  before_filter :current_vendor_required, :only => [:index, :lottory, :mine]

  def index
    if current_vendor.park
      @messages = current_vendor.park.messages.order("id DESC")
    end
  end

  def lottery
    @lotteries = current_vendor.lotteries.order("id DESC").page(params[:page])
  end

  def mine
  end

  def login
    if request.post?
      user = User.login(params[:mobile_num])
      if !sms_code_valid?
        render :json => {:result => false, :msg => "验证码不正确"}
        return
      end
      if user && user.valid?
        user.update_column :role, "vendor"
        session[:vendor_id] = user.id
        render :json => {:result => true, :msg => ""}
      else
        render :json => {:result => false, :msg => "验证码不正确"}
      end
    else
      if current_vendor # already logged in
        redirect_to vendor_index_path
      else
        render :layout => "vendor_login"
      end
    end
  end

  def logout
    session[:vendor_id] = nil
    redirect_to vendor_login_path
  end

  def create_park_statuses
    @park_status = current_vendor.park_statuses.build
    @park_status.status = params[:status]
    @park_status.park = current_vendor.park

    if @park_status.save
      if @park_status.lottery
        render :json => {:result => true, :msg => "恭喜您得到了我们的彩票奖励!"}
      else
        render :json => {:result => true, :msg => "非常感谢您的参与!"}
      end
    else
      render :json => {:result => false, :msg => ""}
    end
  end

  def send_sms_code
    sms_code = SmsCode.new_sms_code(params[:mobile_num])
    if !sms_code.need_set_threshold?
      sms_code.save
      render :json => {:result => true, :msg => "", :sms_code_id => sms_code.id}
    else
      render :json => {:result => false, :msg => "连续发送次数过多，稍后重试"}
    end
  end

  def current_vendor_required
    unless current_vendor
      redirect_to vendor_login_path, :notice => "请先登录"
      return
    end
  end

  def sms_code_valid?
    sms_code = SmsCode.find_by_id(params[:sms_code_id])
    return false unless sms_code
    sms_code.params == params[:sms_code]
  end

end
