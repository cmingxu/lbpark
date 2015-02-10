class VendorController < ApplicationController
  layout "vendor"
  skip_before_filter :verify_authenticity_token
  before_filter :current_vendor_required, :only => [:index, :lottory, :mine]

  def index
    if current_vendor.park
      @messages = current_vendor.park.messages
    end
  end

  def lottery
    @lotteries = current_vendor.lotteries
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
      render :layout => "vendor_login"
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
    param = sms_code.try(:params)
    param[:code] == params[:sms_code]
  end

end
