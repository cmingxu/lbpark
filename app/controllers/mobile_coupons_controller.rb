class MobileCouponsController < MobileController
  before_filter :mobile_bind_required, :only => [:claim, :coupon_show]

  skip_before_filter :verify_authenticity_token

  before_filter  :only => [:index, :show, :coupon_show, :rule, :bind_mobile, :claim] do
    set_wechat_js_config $wechat_api
  end

  before_filter do
    @current_nav = "search"
  end

  def index
  end

  def coupons_nearby
    @location = Location.new params[:lng], params[:lat]
    @coupon_tpls =  CouponTpl.all_visible_around(@location)
    @coupon_tpls = @coupon_tpls.select {|ct| ct.park_id.to_s == params[:park_id].to_s} if params[:park_id].to_i != 0
    render :json => @coupon_tpls.map{|ct| ct.as_api_json(@location) }
  end

  def coupons_owned
    @location = Location.new params[:lng], params[:lat]
    render :json => current_user.coupons_need_to_display.map { |ct| ct.as_api_json(@location) }
  end

  def show
    @coupon_tpl = CouponTpl.find params[:id]
    render :layout => "mobile_no_tab"
  end

  def rule
    render :layout => "mobile_no_tab"
  end


  def claim
    @coupon_tpl = CouponTpl.find params[:id]

    ActiveRecord::Base.transaction do
      if @coupon_tpl.can_be_claimed_by?(current_user)
        begin
          if @coupon = @coupon_tpl.claim_coupon
            @coupon.update_column :user_id, current_user.id
            @order = Order.create_with_coupon(@coupon, request)
            if @coupon.price.zero? # free coupons
              @coupon.claim!
              redirect_to coupon_show_mobile_coupon_path(@coupon) and return
            else
              @coupon.update_attributes coupon_params
              @coupon.order!
              @prepay_id = WechatPay.generate_prepay(@order)
              render :claim
            end
          end
        rescue Exception => e
          @msg = e.message
          render :claim
          raise ActiveRecord::Rollback
        end
      end
    end

    # fallback
    redirect_to mobile_coupons_path
  end

  def coupon_show
    @coupon = current_user.coupons.find_by_id(params[:id])
    redirect_to root_path and return if @coupon.nil?
    render :layout => "mobile_no_tab"
  end

  def notify
    @order = Order.find(params[:id])
    @order.pay!
    @order.coupon.claim!
  end

  def check_if_coupon_used
    @coupon = current_user.coupons.find_by_id(params[:id])
    render :json => { :result => @coupon.used? }
  end

  def bind_mobile
    if request.post?
      if !sms_code_valid?
        render :json => {:result => false, :msg => "验证码不正确"}
        return
      else
        current_user.update_column :phone, params[:mobile_num]
        render :json => {:result => true, :msg => ""}
      end

      return
    end
  end

  def mobile_bind_required
    if current_user.phone.blank?
      session[:redirect_to] = request.path if request.get?
      redirect_to bind_mobile_mobile_coupons_path
      return false
    end
  end

  def coupon_params
    params[:coupon] ||= HashWithIndifferentAccess.new
    params[:coupon][:user_id] = current_user.id
    params.require(:coupon).permit(:user_id, :issued_address, :issued_begin_date)
  end

end
