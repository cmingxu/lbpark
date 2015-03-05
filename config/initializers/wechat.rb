$wechat_api = Wechat::Api.new(Wechat.config.appid, Wechat.config.secret, Wechat.config.access_token, Wechat.config.js_api_ticket)
$vendor_wechat_api = Wechat::Api.new(Wechat.config.vendor_appid, Wechat.config.vendor_secret, Wechat.config.vendor_access_token, Wechat.config.vendor_js_api_ticket)
