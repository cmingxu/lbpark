class Staff::CouponTplsController < Staff::BaseController
  before_filter do
    @active_nav_item = "coupon_tpls"
  end

  def index
    @coupon_tpls = CouponTpl.order("id desc").page params[:page]
  end

  def new
    @coupon_tpl = CouponTpl.new
  end

  def edit
    @coupon_tpl = CouponTpl.find params[:id]
    params[:type] = CouponTpl.coupon_type_to_readable(@coupon_tpl.type)
  end

  def publish
    @coupon_tpl = CouponTpl.find params[:id]
    if @coupon_tpl.publish
      redirect_to :back
    else
      redirect_to :back, :notice => @coupon_tpl.errors.full_messages.first
    end
  end

  def stop
    @coupon_tpl = CouponTpl.find params[:id]
    @coupon_tpl.stop!
    redirect_to :back
  end

  def update
    @coupon_tpl = CouponTpl.find params[:id]
    params[:type] = CouponTpl.coupon_type_to_readable(@coupon_tpl.type)
    if @coupon_tpl.update_attributes coupon_tpl_params
      redirect_to staff_coupon_tpls_path, :notice => "更新成功"
    else
      render :edit, :alert => @coupon_tpl.errors.full_messages.first
    end
  end

  def create
    @coupon_tpl = CouponTpl.coupon_class_name(params[:type]).new coupon_tpl_params
    @coupon_tpl.staff = current_staff
    if @coupon_tpl.save
      redirect_to staff_coupon_tpls_path, :notice => "优惠券创建成功"
    else
      flash.now[:alert] = @coupon_tpl.errors.full_messages.first
      render :new
    end
  end

  def highlight
    @coupon_tpl = CouponTpl.find params[:id]
    if @coupon_tpl.published?
      @coupon_tpl.highlight!
      redirect_to :back
    else
      redirect_to :back, :notice => "发布后才能置顶"
    end
  end

  def dehighlight
    @coupon_tpl = CouponTpl.find params[:id]
    @coupon_tpl.dehighlight!
    redirect_to :back
  end

  def coupon_tpl_params
    params.require(:coupon_tpl).permit(:park_id, :fit_for_date, :quantity, :price, :banner, :notice, :coupon_value, :valid_hour_begin, :valid_hour_end, :lower_limit_for_deduct)
  end
end
