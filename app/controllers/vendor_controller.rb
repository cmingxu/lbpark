class VendorController < ApplicationController
  layout "vendor"

  skip_before_filter :verify_authenticity_token
  before_filter :wechat_browser_required
  before_filter :current_vendor_required, :only => [:index, :lottery, :mine]
  before_filter :mobile_bind_required, :only => [:index, :lottery]
  before_filter :vendor_park_required, :only => [:index, :lottery]

  before_filter  :except => [:login_from_wechat, :create_park_statuses, :bind_mobile] do
    set_wechat_js_config $vendor_wechat_api
  end

  def login_from_wechat
    Rails.logger.info request.env["omniauth.auth"]
    if user = User.login_from_wechat(request.env["omniauth.auth"])
      session[:vendor_id] = user.id
      redirect_to(session[:redirect_to] || vendor_index_path) and return
    end
  end

  def index
    @current_nav = "report"
    @messages = current_vendor.park ? current_vendor.park.messages.order("id DESC").limit(15) : []
  end

  def lottery
    @current_nav = "lottery"
    @lotteries = current_vendor.lotteries.order("id DESC").page(params[:page])
  end

  def mine
    @current_nav = "mine"
  end

  def bind_mobile
    if request.post?
      if !sms_code_valid?
        render :json => {:result => false, :msg => "验证码不正确"}
        return
      else
        current_vendor.update_column :phone, params[:mobile_num]
        render :json => {:result => true, :msg => ""}
      end
    else
      if current_vendor # already logged in
        redirect_to(session[:redirect_to] || vendor_index_path)
      else
        render :layout => "vendor_login"
      end
    end
  end

  def create_park_statuses
    @park_status = current_vendor.park_statuses.build
    @park_status.status = params[:status]
    @park_status.park = current_vendor.park

    if @park_status.save
      if @park_status.lottery
        render :json => {:result => true, :msg => "小哥，恭喜您得到了我们的奖票!"}
      else
        render :json => {:result => true, :msg => "小哥，萝卜已经采纳了您的数据 :)"}
      end
    else
      render :json => {:result => false, :msg => "我们的服务有点问题， 请联系我们的小伙伴！"}
    end
  end


  def high_score_list
    @current_nav = "mine"
  end

  def high_score
    @current_nav = "mine"
  end

  def current_vendor_required
    if !Rails.env.production?
      session[:vendor_id] = User.vendors.first.id
      return
    end
    if current_vendor.nil?
      session[:redirect_to] = request.path if request.get?
      redirect_to "/auth/wechat_vendor" and return
    end
  end

  def mobile_bind_required
    if current_vendor.phone.nil?
      redirect_to vendor_mine_path
    end
  end

  def vendor_park_required
    if current_vendor.park.nil?
      redirect_to vendor_mine_path
    end
  end

  # coupons

  def use_coupon
    coupon = current_park.coupons.find_by_identifier(params[:id])
    if coupon.can_use?
      render :use_coupon_success, :layout => "vendor_no_tab"
    else
      @msg = coupon.unuseable_reason
      render :use_coupon_fail, :layout => "vendor_no_tab"
    end
  end

  def coupons
    respond_to do |format|
      format.html { @coupons = current_park.coupons.used.page params[:page]}
      format.json {}
    end
  end

  def failure
    Rails.logger.error params[:message]
    head 404
  end
end
