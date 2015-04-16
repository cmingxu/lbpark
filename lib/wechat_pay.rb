require 'rest_client'
require 'builder'

class WechatPay
  SignValdiationError = Class.new(StandardError)

  MCH_ID = "1235113502"
  WECHAT_PAY_API = "https://api.mch.weixin.qq.com/pay/unifiedorder"

  def self.generate_prepay(order)
    options = {
      "appid" => Wechat.config.appid,
      "mch_id" => MCH_ID,
      "nonce_str" => SecureRandom.hex(32),
      "body" => URI.encode(order.body),
      "out_trade_no" => order.order_num,
      "total_fee" => order.price,
      "spbill_create_ip" => order.ip,
      "notify_url" => order.notify_url,
      "trade_type" => "JSAPI"
    }

    options["sign"] = sign(options)
    PAYMENT_LOGGER.debug "requst #{options.to_xml}"
    response = RestClient.post(WECHAT_PAY_API, hash_to_xml(options))
    ap response
    PAYMENT_LOGGER.debug "response #{response.body}"
    PAYMENT_LOGGER.debug "response #{response['return_code']}"
    PAYMENT_LOGGER.debug "response #{response['return_msg']}"
    PAYMENT_LOGGER.debug "response #{response['prepay_id']}"

    {:prepay_id => response['prepay_id']}
  end

  def self.sign_valid?(params)
    md5_sign = params[:sign]
    md5_sign == sign(params.except(:sign))
  end

  def self.sign(options)
    Digest::MD5.hexdigest(options.keys.sort.reverse.map do |k|
      next if options[k].blank?
      "#{k}=#{options[k]}"
    end.join("&"))
  end

  def self.hash_to_xml(hash)
    "<xml>"  +
      (hash.keys.map do |k|
      "<#{k}>#{hash[k]}</#{k}>"
    end.join)+
      "</xml>"

  end
end
