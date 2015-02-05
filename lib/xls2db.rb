#编号,照片,属性,名称,类型,地址,性质,车位,坐标（北纬）,坐标（东经）,承包，电话,白天按时,白天按次,晚上按夜,晚上按时,全天按时,全天按次,包月价格,早晚时段,洗车,卫生间,租车,提示,推荐,萝卜头,hda,北京市,海淀区,,,,,
module Xls2db
  def self.import_a(csv_file_name)
    index = 0
    city = nil
    district = nil
    staff = nil
    code_prefix = nil
    CSV.foreach(csv_file_name) do |line|
      if index == 0
        city = line[26]
        district = line[27]
        code_prefix = line[25]
        staff = line[24]
      end
      index += 1
      next if index == 1
      park = Park.find_by_code(code_prefix + line[0]) || Park.new
      park.city = city
      park.lb_staff = staff
      park.district = district
      park.park_type_code = 'A'
      park.code = code_prefix + line[0]
      park.pic_num  = line[1] || line[0]
      park.name     = line[3]
      park.park_type = line[4]
      park.address  = line[5]
      park.originate_from = line[6]
      park.total_count = line[7]
      park.gcj_lng = line[8]
      park.gcj_lat = line[9]
      park.property_owner = line[10]
      if line[11] && line[11].include?(",")
        park.day_first_hour_price, park.day_second_hour_price = line[11].split(",")
      elsif line[11] && line[11].include?("，")
        park.day_first_hour_price, park.day_second_hour_price = line[11].split("，")
      elsif line[11]
        park.day_first_hour_price = line[11]
      end
      park.day_price_per_time = line[12]
      park.night_price_per_night = line[13]
      park.night_price_per_hour = line[14]
      park.whole_day_price_per_hour = line[15]
      park.whole_day_price_per_time = line[16]

      park.month_price = line[17]
      if line[18] && line[18].include?(",")
        park.day_time_begin, park.day_time_end = line[18].split(",")
        park.night_time_end, park.night_time_begin = line[18].split(",")
      end


      if line[18] && line[18].include?("，")
        park.day_time_begin, park.day_time_end = line[18].split("，")
        park.night_time_end, park.night_time_begin = line[18].split("，")
      end

      park.day_time_begin = 7 if park.day_time_begin.blank?
      park.day_time_end = 21 if park.day_time_end.blank?
      park.night_time_begin = 21 if park.night_time_begin.blank?
      park.night_time_end = 7 if park.night_time_end.blank?

      park.service_wash = true if line[19].present?
      park.service_wc   = true if line[20].present?
      park.service_rent = true if line[21].present?
      park.service_rent_company = line[21] if park.service_rent
      park.tips   = line[22]
      park.is_recommend = true if line[23].present?

      park.save
    end
  end

  def self.import_b(csv_file_name)
    index = 0
    city = nil
    district = nil
    staff = nil
    code_prefix = nil
    CSV.foreach(csv_file_name) do |line|
      if index == 0
        staff = line[7]
        code_prefix = line[8]
        city = line[9]
        district = line[10]
      end
      index += 1
      next if index == 1
      park = Park.find_by_code(code_prefix+line[0]) || Park.new
      park.city = city
      park.lb_staff = staff
      park.district = district
      park.park_type_code = 'B'
      park.code = code_prefix + line[0]
      park.pic_num  = code_prefix + line[0]
      park.name     = line[1]
      park.park_type = line[2]
      park.gcj_lng = line[3]
      park.gcj_lat = line[4]
      park.tips = line[5]
      park.save
    end
  end

  def self.import_c(csv_file_name)
    index = 0
    city = nil
    district = nil
    staff = nil
    code_prefix = nil
    CSV.foreach(csv_file_name) do |line|
      if index == 0
        staff = line[9]
        code_prefix = line[10]
        city = line[11]
        district = line[12]
      end
      index += 1
      next if index == 1
      park = Park.find_by_code(code_prefix+line[0]) || Park.new
      park.city = city
      park.lb_staff = staff
      park.district = district
      park.park_type_code = 'C'
      park.code = code_prefix + line[0]
      park.pic_num  = code_prefix + line[0]

      park.name     = line[1]
      park.park_type = line[2]
      park.gcj_lng = line[3]
      park.gcj_lat = line[4]
      park.tips = line[5]

      park.day_price_per_time = line[8]
      park.month_price = line[7]
      if line[6] && line[6].include?(",")
        park.day_first_hour_price, park.day_second_hour_price = line[6].split(",")
      elsif line[6] && line[6].include?("，")
        park.day_first_hour_price, park.day_second_hour_price = line[6].split("，")
      elsif line[6]
        park.day_first_hour_price = line[6]
      end


      park.day_time_begin = 7 if park.day_time_begin.blank?
      park.day_time_end = 21 if park.day_time_end.blank?
      park.night_time_begin = 21 if park.night_time_begin.blank?
      park.night_time_end = 7 if park.night_time_end.blank?

      park.whole_day_price_per_time = 0 if line[5].present?

      park.tips = line[5]
      park.save
    end

  end
end
