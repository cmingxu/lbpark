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
        :current_price => p.current_price,
        :tags => p.tags
      }
    end)

  end

end
