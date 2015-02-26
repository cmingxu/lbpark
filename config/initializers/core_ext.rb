class String
  class << self
    def lb_encode(str, shift = 0)
      str = Base64.encode64(str)
      str = str.reverse
      str
    end

    def lb_decode(str, shift = 0)
      str = str.reverse
      str = Base64.decode64(str)
      str
    end
  end
end
