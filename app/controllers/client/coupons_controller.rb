class Client::CouponsController < Client::BaseController
  before_filter do
    @active_nav_item = params[:coupon_type]
    @park = current_client.parks.find_by_id(params[:park_id]) || current_client.parks.first
  end

  def index
    @coupon_tpls = @park.coupon_tpls.order("id desc").page params[:page]
  end

  def new
    @coupon_tpl = @park.coupon_tpls.new
  end

  def edit
    @coupon_tpl = @park.coupon_tpls.find params[:id]
    params[:type] = CouponTpl.coupon_type_to_readable(@coupon_tpl.type)
  end

  def publish
    @coupon_tpl = @park.coupon_tpls.find params[:id]
    if @coupon_tpl.publish
      redirect_to :back
    else
      redirect_to :back, :notice => @coupon_tpl.errors.full_messages.first
    end
  end

  def stop
    @coupon_tpl = @park.coupon_tpls.find params[:id]
    @coupon_tpl.stop!
    redirect_to :back
  end

  def coupon_list
    @coupon_tpl = CouponTpl.find params[:coupon_tpl_id]
    coupon_tpl_scope = @coupon_tpl.coupons
    if params[:status]
      coupon_tpl_scope = coupon_tpl_scope.where(:status => params[:status])
    end
    @coupons = coupon_tpl_scope.page params[:page]
  end

  def create
    @coupon_tpl = CouponTpl.coupon_class_name(params[:type]).new coupon_tpl_params
    if @coupon_tpl.save
      redirect_to client_coupons_path, :notice => "优惠券创建成功"
    else
      flash.now[:alert] = @coupon_tpl.errors.full_messages.first
      render :new
    end
  end

  def coupon_tpl_params
    params.require(:coupon_tpl).permit(:park_id, :fit_for_date, :quantity, :price, :banner, :notice, :coupon_value,
                                       :valid_hour_begin, :valid_hour_end, :lower_limit_for_deduct, :valid_dates, :park_space_choose_enabled)
  end
end
