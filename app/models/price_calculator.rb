class PriceCalculator
  attr_accessor :park

  def initialize(park)
    @park = park
  end

  def desc
    puts "current_price #{self.current_price}"
    puts "================================"
    puts "day_price     #{self.day_price}"
    puts "day_unit      #{self.day_unit}"
    puts "night_price   #{self.night_price}"
    puts "night_unit    #{self.night_unit}"
  end

  def current_price
    price = if by_month_only?
      ""
    elsif by_whole_day?
      park.whole_day_price_per_time || park.whole_day_price_per_hour
    elsif price_by_day?
      park.day_first_hour_price || park.day_price_per_time
    elsif !price_by_day? # 夜间价格/禁停
      park.night_price_per_hour || park.night_price_per_night
    end

    case price = price.to_s
    when  /^0\..*/
      "<span class='zero_notion'>0.</span>" + price.split(".")[1]
    when /\d{1}.0/
      price[0]
    when /\d{2}.0/
      price[0] + "<span class='zero_notion'>#{price[1]}</span>"
    else
      price
    end
  end

  def day_price
    if by_month_only?
      ""
    elsif by_whole_day?
      park.whole_day_price_per_time || park.whole_day_price_per_hour
    else
      park.day_first_hour_price || park.day_price_per_time
    end
  end

  def night_price
    if by_month_only?
      ""
    elsif by_whole_day?
      park.whole_day_price_per_time || park.whole_day_price_per_hour
    elsif day_only?
      ""
    else
      park.night_price_per_night || park.night_price_per_hour
    end
  end

  def day_unit
    if by_month_only?
      ""
    elsif by_whole_day?
      park.whole_day_price_per_time.present? ? "次" : "时"
    else
      park.day_first_hour_price.present? ? "时" : "次"
    end
  end

  def night_unit
    if by_month_only?
      ""
    elsif by_whole_day?
      park.whole_day_price_per_time.present? ? "次" : "时"
    elsif day_only?
      ""
    else
      park.night_price_per_night.present? ? "夜" : "时"
    end
  end

  def day_time_range
    "#{park.day_time_begin}:00 - #{park.day_time_end}:00"
  end

  def night_time_range
    "#{park.night_time_begin}:00 - #{park.night_time_end}:00"
  end

  def no_parking?
    return false if park.park_type_code == "C"
    return false if park.park_type_code == "B"
    return false if by_month_only?
    return false if by_whole_day?
    return day_only? && !price_by_day?
  end

  # 无夜间价格 - 禁停
  def day_only?
    return false if (by_month_only? || by_whole_day?)
    park.night_price_per_hour.blank? && park.night_price_per_night.blank?
  end

  def by_month_only?
    park.month_price.present? &&
      park.whole_day_price_per_time.blank? &&
      park.whole_day_price_per_hour.blank? &&
      park.night_price_per_night.blank? &&
      park.night_price_per_hour.blank? &&
      park.day_first_hour_price.blank? &&
      park.day_price_per_time.blank?
  end

  def by_whole_day?
    park.whole_day_price_per_hour.present? || park.whole_day_price_per_time.present?
  end

  def price_by_day?
    Time.now.hour >= park.day_time_begin && Time.now.hour < park.day_time_end
  end


end
