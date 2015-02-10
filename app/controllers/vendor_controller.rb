class VendorController < ApplicationController
  layout "vendor"
  skip_before_filter :verify_authenticity_token
  before_filter :current_vendor_required, :only => [:index, :lottory, :mine]

  def index
  end

  def lottery
  end

  def mine
  end

  def login
  end

  def send_sms_code
    sms_code = SmsCode.new_sms_code(params[:mobile_num])
    if !sms_code.need_set_threshold?
      sms_code.save
      render :json => {:result => true, :msg => ""}
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

end
