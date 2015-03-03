#require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class WechatUser < Wechat
      option :name, "wechat_user"
      option :callback_path, "/auth/wechat_user/callback"
    end

    class WechatVendor < Wechat
      option :name, "wechat_vendor"
      option :callback_path, "/auth/wechat_vendor/callback"
    end
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  wechat_config = OpenStruct.new(YAML.load(File.read(Rails.root.join("config/wechat.yml")))[Rails.env])
  provider :wechat_vendor, wechat_config.vendor_apiid, wechat_config.vendor_secret
  provider :wechat_vendor, wechat_config.apiid, wechat_config.secret
end
