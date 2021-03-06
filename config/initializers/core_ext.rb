class String
  class << self
    def lb_encode(str, shift = 0)
      str = Base64.encode64(str).strip
      str = str.reverse
      str =  str[shift..-1] + str[0..(shift-1)]
      str
    end

    def lb_decode(str, shift = 0)
      str =  str[(str.length - shift)..-1] +  str[0..(str.length - shift-1)]
      str = str.reverse
      str = Base64.decode64(str)
      str
    end
  end
end

class Time
  def to_zh_m_d
    "#{strftime('%m').to_i}月#{strftime('%d').to_i}日"
  end

  def to_zh_m_d_dot
    "#{strftime('%m').to_i}.#{strftime('%d').to_i}"
  end
end
