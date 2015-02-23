class Staff::WechatUsersController < Staff::BaseController
  before_filter do
  end

  def index
    @wechat_users = WechatUser.page params[:page]
  end
end
