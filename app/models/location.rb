class Location
  EARTH_RADIUS = 6372797
  attr_accessor :lng, :lat


  def initialize(lng, lat)
    @lng = lng.to_f
    @lat = lat.to_f
  end


  def around(radius)
    location_radius = 180 / Math::PI * radius / EARTH_RADIUS
    p1 = self.class.new(@lng - location_radius, @lat - location_radius)
    p2 = self.class.new(@lng + location_radius, @lat + location_radius)
    LbRange.new p1, p2
  end

end
