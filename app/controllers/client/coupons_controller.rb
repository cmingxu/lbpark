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


  def create
    @coupon_tpl = CouponTpl.coupon_class_name(params[:type]).new coupon_tpl_params
    @coupon_tpl.staff = current_staff
    if @coupon_tpl.save
      redirect_to client_coupon_tpls_path, :notice => "优惠券创建成功"
    else
      flash.now[:alert] = @coupon_tpl.errors.full_messages.first
      render :new
    end
  end
end
