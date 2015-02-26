class Api::ParksController < Api::BaseController
  def index
    @location = Location.new params[:lng], params[:lat]
    park_json = (Park.within_range(@location.around(1000)).includes(:park_pics).all.map do |p|
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
        :day_price => p.day_price,
        :day_price_unit => p.day_unit,
        :night_time_range => p.night_time_range,
        :night_price => p.night_price,
        :night_price_unit => p.night_unit,
        :park_lb_desc => p.lb_desc,
        :thumb_pic_url => p.thump_pic_url,
        :no_parking => p.no_parking?
      }
    end).to_json
    shift = rand(park_json.length).to_i
    response.headers["X-LB-SHIFT"] = shift.to_s
    render :text => String.lb_encode(park_json, shift)
  end

end
