# == Schema Information
#
# Table name: park_infos
#
#  id                    :integer          not null, primary key
#  park_id               :integer
#  day_time              :text
#  night_time            :text
#  day_price_desc        :text
#  all_day_price_desc    :text
#  night_price_desc      :text
#  times_price_desc      :text
#  month_price_desc      :text
#  service_wc_desc       :text
#  service_wash_desc     :text
#  total_count_desc      :text
#  day_price_desc_temp   :text
#  night_price_desc_temp :text
#  distance_desc         :text
#  created_at            :datetime
#  updated_at            :datetime
#

class ParkInfo < ActiveRecord::Base
end
