class Staff::QrCodesController < Staff::BaseController
  def index
    @qr_codes = QrCode.page params[:page]
  end

  def new
    @qr_code = QrCode.new(:which_wechat_account => "vendor")
  end

  def create
    @qr_code = QrCode.new qr_code_params
    if @qr_code.save
      redirect_to staff_qr_codes_path, :notice => "成功"
    else
      redirect_to staff_qr_codes_path, :laert => "失败"
    end
  end

  def qr_code_params
    params.require(:qr_code).permit(:which_wechat_account, :mark, :scene_str)
  end
end
