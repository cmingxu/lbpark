module WechatApi
  class AccessToken
    attr_accessor :grant_type, :appid, :secret, :access_token, :expire_at

    def initialize(grant_type, appid, secret)
      @grant_type = grant_type
      @appid      = appid
      @secret     = secret
      @expire_at  = 1.day.ago
      @access_token = nil

      refresh!
    end

    def refresh!
      @access_token = @expire_at = nil
      response = Utils.get(access_token_entry_point)
      @access_token = response["access_token"]
      @expire_at = Time.now + response["expires_in"]
    end

    def valid?
      Time.now < @expire_at
    end

    private
    def access_token_entry_point
      EntryPoint::ACCESS_TOKEN + "?" + {:grant_type => @grant_type, :appid => @appid, :secret => @secret}.to_query
    end
  end
end
