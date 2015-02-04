module RedisKey
  class << self
    def park_status_key(park)
      "park_status_#{park.id}"
    end
  end
end
