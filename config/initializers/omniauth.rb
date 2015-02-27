Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :wechat, Wechat.config.apiid, Wechat.config.secret
  provider :wechat, "wx74e2705cf0a80df8", "7506cf446cb2fa21f7ae0d1b4ae66da4"
  authorize_params  { :scope => :snsapi_base }
end
