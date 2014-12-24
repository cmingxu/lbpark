desc 'Convert data from old db to current ar'

task convert: [:environment] do
  $spec = {
    :username => "root",
    :password => "",
    :database => "ruyipark",
    :adapter => :mysql2
  }

  class Old < ActiveRecord::Base; self.abstract_class = true; self.establish_connection $spec; end

  class OldPark         < Old; self.table_name = "park" end
  class OldParkDesc      < Old; self.table_name = "park_desc" end
  class OldParkBiz      < Old; self.table_name = "park_biz" end
  class OldParkFalut    < Old; self.table_name = "park_fault" end
  class OldParkStatus   < Old; self.table_name = "park_status" end
  class OldUserFavorite < Old; self.table_name = "user_favorite" end
  class OldUserToken    < Old; self.table_name = "user_token" end

  puts OldPark.all.count
  puts OldParkBiz.all.count
  puts OldParkFalut.all.count
  puts OldParkStatus.all.count
  puts OldUserFavorite.all.count
  puts OldUserToken.all.count

  OldPark.find_each do |o|
    Park.new do |p|
      p.id    = o.id
      p.code  = o.sn
      p.province  = o.province
      p.city = o.city
      p.district = o.district
      p.name = o.name
      p.address = o.address
      p.park_type = o.changed_type
      p.park_type_code = o.ptype
      p.total_count  = o.total_count
      p.gcj_lat  = o.gcj_lat
      p.gcj_lng = o.gcj_lng
      p.whole_day = o.is_all_day
      p.day_only = o.is_only_day
      p.day_time_begin = o.day_time_start
      p.day_time_end = o.day_time_end
      p.day_price = o.day_price
      p.day_first_hour_price = o.day_first_hour_price
      p.day_second_hour_price = o.day_second_hour_price
      p.night_time_begin = o.night_time_start
      p.night_time_end = o.night_time_end
      p.night_price = o.night_price
      p.night_price_hour = o.night_price_hour
      p.times_price = o.times_price
      p.service_month = o.service_month
      p.month_price = o.month_price
      p.service_wash = o.service_wash
      p.service_wc = o.service_wc
      p.service_repair = o.service_repair
      p.service_rent = o.service_rent
      p.service_rent_company = o.service_rent_company
      p.service_group = o.service_group
      p.service_times = o.service_times
      p.is_recommend = o.is_recommend
      p.has_service_coupon = o.service_coupon
      p.has_service_point = o.service_point
      p.is_only_service = o.is_only_service
      p.times_price_all_day = o.times_price_all_day
      p.tips = o.tips
    end.save!
  end



  OldParkDesc.find_each do |pb|
    ParkInfo.new(pb.attributes).save!
  end

  OldParkBiz.find_each do |pb|
    ParkOwner.new do |po|
      po.id = pb.id
      po.park_id =  pb.park_id
      po.wgs_lat = pb.wgs_lat
      po.wgs_lng = pb.wgs_lng
      po.contract = pb.contract
      po.contract_phone = pb.contract_phone
      po.ownership = pb.ownership
      po.owner = pb.owner
      po.desc = pb.comment
      po.maintainer = pb.vindicator
    end.save
  end

  OldUserToken.find_each do |out|
    User.new do |ut|
      ut.phone = out.phone
      ut.created_at = out.cts
      ut.updated_at = out.uts
    end
  end
end
