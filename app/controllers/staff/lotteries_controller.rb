class Staff::LotteriesController < Staff::BaseController
  before_filter do
    @active_nav_item = "lotteries"
  end

  def index
    @lotteries = Lottery.order("id DESC").page params[:page]
  end
end
