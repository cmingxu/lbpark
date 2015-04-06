require 'digest/md5'

class LbSmsSender
  include HTTParty
  cattr_accessor :timestamp

  MESSAGE_TEMPLATE = {
    :test => "3427",
    :vendor_login => "3440",
    :vendor_lottery_get => "3441",
    :vendor_lottery_miss => "3442",
  }.with_indifferent_access

  API_POINT   = "https://api.ucpaas.com"
  ACCOUNT_SID = "87722e65dc2ced5623bf0ddde99a0f29"
  AUTH_TOKEN  = "4e8b245a9acf103126937ce33b4a8c38"
  APP_ID      = "6e81cbe3d2054ec6b480193acf19bee7"
  SOFT_VERSION = "2014-06-30"

  DEFAULT_PARMAS = {
    "appId" =>  APP_ID
  }

  def self.send_sms_to_mobile(mobile, message_template, params)
    self.timestamp = Time.now.strftime("%Y%m%d%H%M%S")

    p = { :templateSMS =>
      DEFAULT_PARMAS.merge( :to => mobile, :templateId => MESSAGE_TEMPLATE[message_template], :param => params)
    }

    SMS_LOGGER.debug "sending message #{message_template}  #{params} to  #{mobile}, #{p}"

    begin
      self.post(request_uri, :body => p.to_json, :headers => request_headers)
      [true, nil]
    rescue Exception => e
      [false, e]
    end
  end

  def self.send_sms(user, message_template, params)
    return [false, "no mobile for user"] if user.mobile.blank?
    self.timestamp = Time.now.strftime("%Y%m%d%H%M%S")

    p = { :templateSMS =>
          DEFAULT_PARMAS.merge( :to => user.try(:mobile), :templateId => MESSAGE_TEMPLATE[message_template], :param => params)
    }

    SMS_LOGGER.debug "sending message #{message_template} to user #{user.email} / #{user.try(:mobile)}"
    self.post(request_uri, :body => p.to_json, :headers => request_headers)
  end

  def self.verify_sms(user, sms_notice)
    self.send_sms(user, :verify, sms_notice.param)
  end

  def self.withdraw(user, sms_notice)
    self.send_sms(user, :verify, sms_notice.param)
  end

  private
  class << self
    def request_uri
      "#{API_POINT}/#{SOFT_VERSION}/Accounts/#{ACCOUNT_SID}/Messages/templateSMS?sig=#{sign}"
    end

    def request_headers
      {
        "Accept" => "application/json",
        "Content-Type" => "application/json;charset=utf-8",
        "Authorization" => Base64.encode64("#{ACCOUNT_SID}:#{self.timestamp}").gsub("\n", "")
      }
    end

    def sign
      Digest::MD5.hexdigest("#{ACCOUNT_SID}#{AUTH_TOKEN}#{self.timestamp}").upcase
    end
  end
end
