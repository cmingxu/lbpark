class Api::ParksController < Api::BaseController
  def index
    @location = Location.new params[:lng], params[:lat]
    render :json => (Park.within_range(@location.around(1000)).all.map do |p|
      {
        :lng => p.lng,
        :lat => p.lat,
        :id  => p.id,
        :name => p.name,
        :park_type => p.park_type,
        :park_type_code => p.park_type_code,
        :tips => p.tips,
        :busy_status => p.busy_status,
        :tags => p.tags,
        :current_price => p.current_price,
        :day_time_range => p.day_time_range,
        :day_price => p.day_price_per_time,
        :day_price_unit => p.day_price_unit,
        :night_time_range => p.night_time_range,
        :night_price => p.night_price_per_hour,
        :night_price_unit => p.day_price_unit,
        :park_lb_desc => p.lb_desc
      }
    end)

  end

end
