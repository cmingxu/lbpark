class Staff::WechatUsersController < Staff::BaseController
  before_filter do
    @active_nav_item = "wechat_users"
  end

  def index
    @wechat_users = WechatUser.order("id desc").page params[:page]
  end
end
