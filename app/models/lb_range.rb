class LbRange
  attr_accessor :p1, :p2

  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
  end


  def distance
    dtor = Math::PI/180
    r = 6378.14*1000

    rlat1 = p1.lat * dtor
    rlong1 = p1.lng * dtor
    rlat2 = p2.lat * dtor
    rlong2 = p2.lng * dtor

    dlon = rlong1 - rlong2
    dlat = rlat1 - rlat2

    a = power(Math::sin(dlat/2), 2) + Math::cos(rlat1) * Math::cos(rlat2) * power(Math::sin(dlon/2), 2)
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    (r * c).ceil
  end

  def power(num, pow)
    num ** pow
  end

end
