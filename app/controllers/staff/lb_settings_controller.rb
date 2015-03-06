class Staff::LbSettingsController < Staff::BaseController
  before_filter do
    @active_nav_item = "lb_settings"
  end

  def index
    @lb_settings = LbSetting.all
  end

  def edit
    @lb_setting = LbSetting.find params[:id]
  end

  def new
    @lb_setting = LbSetting.new
  end

  def create
    LbSetting.send("#{params[:var]}=", params[:lb_value])
    redirect_to staff_lb_settings_path
  end

  def destroy
    LbSetting.find(params[:id]).destroy
    redirect_to staff_lb_settings_path
  end
end
