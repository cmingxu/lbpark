class Staff::WechatUserActivitiesController < Staff::BaseController
  before_filter do
    @active_nav_item = "wechat_users"
    @wechat_user = WechatUser.find params[:wechat_user_id]
  end

  def index
    @wechat_user_activities = @wechat_user.wechat_user_activities
  end
end
