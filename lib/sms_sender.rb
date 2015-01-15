require 'digest/md5'

module SmsSender
  include HTTParty
  cattr_accessor :timestamp

  MESSAGE_TEMPLATE = {
    :test => "2247",
    :withdraw => "2303",
    :verify => "2302"
  }.with_indifferent_access

  API_POINT   = "https://api.ucpaas.com"
  ACCOUNT_SID = "aa7babf14bfa412fdb44d650d557f8c3"
  AUTH_TOKEN  = "16ec16484acae680df94a436e20e623a"
  APP_ID      = "8de26cc1d7d24fc1818e9471f9f8b637"
  SOFT_VERSION = "2014-06-30"

  DEFAULT_PARMAS = {
    "appId" =>  APP_ID
  }

  def self.send_sms_to_mobile(mobile, message_template, params)
    self.timestamp = Time.now.strftime("%Y%m%d%H%M%S")

    p = { :templateSMS =>
      DEFAULT_PARMAS.merge( :to => mobile, :templateId => MESSAGE_TEMPLATE[message_template], :param => params)
    }

    SMS_LOGGER.debug "sending message #{message_template}  #{params} to  #{mobile}"

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
