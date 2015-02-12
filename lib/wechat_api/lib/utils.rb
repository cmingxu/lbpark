module WechatApi
  module Utils
    extend Httparty

    def self.sha1_sign(str_to_sign)
      Digest::SHA1.hexdigest(str_to_sign)
    end

    def self.wx_get(url)
      self.get(url)
    end
  end
end
