class MobileCouponsController < MobileController
  before_filter :mobile_bind_required, :only => [:claim, :coupon_show]

  skip_before_filter :verify_authenticity_token

  before_filter  :only => [:index, :show, :coupon_show, :rule, :bind_mobile, :claim] do
    set_wechat_js_config $wechat_api
  end

  before_filter :only => [:claim] do
    set_pay_sign
  end

  before_filter do
    @current_nav = "search"
  end

  skip_before_filter :login_required, :only => [:notify]

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
    @coupon_tpl = CouponTpl.find params[:tpl_id]

    ActiveRecord::Base.transaction do
      if @coupon_tpl.can_be_claimed_by?(current_user)
        begin
          if @coupon = @coupon_tpl.claim_coupon
            @coupon.update_column :user_id, current_user.id
            @coupon.update_column :quantity, coupon_params[:quantity].to_i.abs < 1 ?  1 : coupon_params[:quantity].to_i.abs
            @coupon.reload
            @order = Order.create_with_coupon(@coupon, request.headers["X-Real-IP"])
            if @coupon.price.zero? # free coupons
              @coupon.claim!
              redirect_to coupon_show_mobile_coupon_path(@coupon) and return
            else
              @coupon.update_attributes coupon_params
              @coupon.order!
              @r = WxPay::Service.invoke_unifiedorder(@order.prepay_params)
              Rails.logger.debug @r
              if @r.success?
                @order.update_column :prepay_id, @r['prepay_id']
                @pay_config[:package] = "prepay_id=#{@r['prepay_id']}"
                @pay_config[:paySign] = WxPay::Sign.generate(@pay_config)
                render :claim and return
              else
                raise ActiveRecord::Rollback
              end
            end
          end
        rescue Exception => e
          Rails.logger.error e
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
    result = Hash.from_xml(request.body.read)["xml"]
    if result['result_code'] == result['return_code'] && result['return_code'] == 'SUCCESS'#WxPay::Sign.verify?(result)
      @order = Order.find_by_order_num(result["order_num"])
      @order.transaction_id = result['transaction_id']
      @order.bank_type      = result['bank_type']
      @order.paid_at        = Time.now
      @order.pay! if @order.not_paid?
      @order.coupon.pay! if @order.coupon.ordered?
      render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
    else
      render :xml => {return_code: "SUCCESS", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
    end
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
    params.require(:coupon).permit(:user_id, :issued_address, :issued_begin_date, :quantity)
  end

end
