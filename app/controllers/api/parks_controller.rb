class Api::ParksController < ApplicationController
  def index
    @location = Location.new params[:lng], params[:lat]
    render :json => (Park.within_range(@location.around(1000)).all.map do |p|
      {
        :lng => p.gcj_lng,
        :lat => p.gcj_lat,
        :id  => p.id,
        :name => p.name
      }
    end)

  end

end
