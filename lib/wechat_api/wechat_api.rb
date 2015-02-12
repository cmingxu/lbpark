$LOAD_PATH.unshift(File.epxand_path(File.join(File.dirname(__FILE__), 'lib')))

require 'access_token'
require 'httparty'

module WechatApi
  def self.on_wechat_request(request)
  end

  module EntryPoint
    ACCESS_TOKEN = "https://api.weixin.qq.com/cgi-bin/token"
  end
end
