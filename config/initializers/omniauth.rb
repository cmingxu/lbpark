Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :wechat, Wechat.config.apiid, Wechat.config.secret
  provider :wechat, "wxa54c754042737ab9", "20a993eb419d0306c403fc184a391af1"
end
