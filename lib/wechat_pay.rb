require 'rest_client'
require 'builder'

class WechatPay
  SignValdiationError = Class.new(StandardError)
  ResponseNotValidError = Class.new(StandardError)
  ResponseFailError = Class.new(StandardError)

  MCH_ID = "1235113502"
  WECHAT_PAY_API = "https://api.mch.weixin.qq.com/pay/unifiedorder"

  def self.generate_prepay(order)
    options = {
      "appid" => Wechat.config.appid,
      "mch_id" => MCH_ID,
      "nonce_str" => SecureRandom.hex(10),
      "body" => URI.encode(order.body),
      "out_trade_no" => order.order_num,
      "total_fee" => order.price,
      "spbill_create_ip" => order.ip,
      "notify_url" => order.notify_url,
      "trade_type" => "JSAPI",
      "openid" => order.user.openid
    }

    options["sign"] = sign(options)
    PAYMENT_LOGGER.debug "requst #{hash_to_xml(options)}"
    response = RestClient.post(WECHAT_PAY_API, hash_to_xml(options))
    hash = Hash.from_xml(response)["xml"]
    raise ResponseFailError.new(hash["return_msg"]) if hash["return_code"] == "FAIL"
    raise ResponseNotValidError.new(hash["return_msg"]) if !sign_valid?(hash)
    raise ResponseFailError.new(hash["error_code_des"]) if hash["result_code"] == "FAIL"
    PAYMENT_LOGGER.debug "response #{hash}"
    hash['prepay_id']
  end

  def self.sign_valid?(params)
    md5_sign = params["sign"]
    md5_sign == sign(params.except("sign"))
  end

  def self.sign(options)
    Digest::MD5.hexdigest(options.keys.sort.map do |k|
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
