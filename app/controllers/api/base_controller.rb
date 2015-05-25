class Api::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:send_sms_code]
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def send_sms_code
    sms_code = SmsCode.new_sms_code(params[:mobile_num])
    if !sms_code.need_set_threshold?
      sms_code.save
      render :json => {:result => true, :msg => "", :sms_code_id => sms_code.id}
    else
      render :json => {:result => false, :msg => "连续发送次数过多，稍后重试"}
    end
  end

  def record_not_found
    render :json => {}, :status => 404
  end
end
