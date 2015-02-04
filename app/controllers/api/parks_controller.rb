class Api::ParksController < ApplicationController
  def index
    @location = Location.new params[:lng], params[:lat]
    render :json => (Park.with_park_type_code('A').within_range(@location.around(1000)).all.map do |p|
      {
        :lng => p.lng,
        :lat => p.lat,
        :id  => p.id,
        :name => p.name,
        :park_type => p.park_type,
        :tips => p.tips,
        :busy_status => 1,
        :tags => p.tags,
        :current_price => p.current_price,
        :day_time_range => p.day_time_range,
        :day_price => p.day_price,
        :day_price_unit => p.day_price_unit,
        :night_time_range => p.night_time_range,
        :night_price => p.night_price,
        :night_price_unit => p.day_price_unit
      }
    end)

  end

end
