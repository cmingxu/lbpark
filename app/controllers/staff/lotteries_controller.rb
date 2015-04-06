class Staff::LotteriesController < Staff::BaseController
  before_filter do
    @active_nav_item = "lotteries"
  end

  def index
    @lotteries = Lottery.order("id DESC").page params[:page]
  end

  def edit
    @lottery = Lottery.find params[:id]
  end

  def update
    @l = Lottery.find params[:id]
    @l.serial_num = params[:lottery][:serial_num]
    @l.save
    redirect_to :back
  end

  def open
    serial_num = params[:serial_num]
    if serial_num.presence
      res, msg = Lottery.serial_num_valid?(serial_num.presence.split(","))
      if res
        Lottery.where(:open_num => params[:open_num]).map(&:buy)
        Lottery.open(params[:open_num], serial_num.split(",").map(&:to_i))
        redirect_to staff_lotteries_path, :notice => "开奖成功"
      else
        redirect_to staff_lotteries_path, :alert => "开奖号码不正确, #{msg}"
      end
    else
      redirect_to staff_lotteries_path, :alert => "开奖号码空"
    end
  end
end
