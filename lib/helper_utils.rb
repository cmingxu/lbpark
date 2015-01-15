module HelperUtils
  def odd_float_to_int(float)
    return 0 if float.nil?
    float.to_f * (10 ** 4) / (10 ** 2)
  end

  def odd_int_to_float(int)
    return 0.0 if int.nil?
    int.to_f / (10 ** 2).to_f
  end

  def rmb_float_to_int(float)
    return 0 if float.nil?
    float.to_f * (10 ** 4) / (10 ** 2)
  end

  def rmb_int_to_float(int)
    return 0.0 if int.nil?
    int.to_i / (10 ** 2).to_f
  end

  def btc_float_to_int(float)
    return 0 if float.to_f.nil?
    float.to_f * (10 ** 10) / (10 ** 2)
  end

  def btc_int_to_float(int)
    return 0.0 if int.nil?
    int.to_i / (10 ** 8).to_f
  end

  def odds_in_percentage
    "%d%" % (Settings.odds * 100)
  end

  def interest_in_percentage
    "%d%" % (Settings.platform_interest * 100)
  end

  def open_at_code(open_at)
    Time.at(open_at).strftime("%Y%m%d%H%M")
  end
end
