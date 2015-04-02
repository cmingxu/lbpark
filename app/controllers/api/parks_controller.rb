class Api::ParksController < Api::BaseController
  def index
    if params[:zoom] && params[:zoom].to_i > 13
      @location = Location.new params[:lng], params[:lat]
      @coupon_tpls = CouponTpl.all_visible_around(@location)
      park_json = Park.within_range(@location.around(Settings.parks_visible_range)).includes(:park_pics).all.map do |p|
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
          :no_parking => p.no_parking?,
          :day_only => p.day_only?,
          :free_today_coupon => @coupon_tpls.any?{|ct| ct.park_id == p.id && ct.free? && ct.fit_for_date == Date.today },
          :free_tomorrow_coupon => @coupon_tpls.any?{|ct| ct.park_id == p.id && ct.free? && ct.fit_for_date != Date.today },
          :monthly_coupon => @coupon_tpls.any?{|ct| ct.park_id == p.id &&  ct.monthly? },
          :quarterly_coupon => @coupon_tpls.any?{|ct| ct.park_id == p.id &&  ct.quarterly? }
        }
      end
    else
      @location = Location.new params[:lng], params[:lat]
      range = 2 ** (17 - params[:zoom].to_i)
      random = 2 ** (17 - params[:zoom].to_i)
      park_json = Park.within_range(@location.around(Settings.parks_visible_range * range)).rand_visible(random).map do |p|
        {
          :lng => p.lng,
          :lat => p.lat,
          :id  => p.id,
          :small_place_holder => true
        }

      end
        Rails.logger.error range
        Rails.logger.error park_json.size
    end

    if Settings.park_info_encrypted
      park_json = park_json.to_json
      shift = rand(park_json.length).to_i
      response.headers["X-LB-SHIFT"] = shift.to_s
      render :json => {data: String.lb_encode(park_json, shift) }
    else
      render :json => { data: park_json }
    end
  end

end
