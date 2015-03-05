# -*- encoding : utf-8 -*-
class SyncWechatUser
  @queue = :sync_wechat_user

  def self.perform(id)
    LB_WECHAT_LOGGER.debug "entering sync wechat user #{id}"
    wu =  WechatUser.find(id)
    wu.sync_wechat_user!
  end
end


