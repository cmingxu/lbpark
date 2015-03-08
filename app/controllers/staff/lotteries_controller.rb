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
end
