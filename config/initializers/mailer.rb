ActionMailer::Base.default_url_options = { host: Settings.host }
ActionMailer::Base.logger = MAIL_LOGGER
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "smtp.exmail.qq.com",
  :port => 25,
  :domain => "900bit.com",
  :user_name => "noreply@900bit.com",
  :password => "lm663400",
  :authentication => :login
}

ActionMailer::Base.raise_delivery_errors = true


