# == Schema Information
#
# Table name: park_imports
#
#  id                    :integer          not null, primary key
#  import_id             :integer
#  park_id               :integer
#  code                  :string(255)
#  province              :string(255)
#  city                  :string(255)
#  district              :string(255)
#  name                  :string(255)
#  address               :string(255)
#  park_type             :string(255)
#  park_type_code        :string(255)
#  total_count           :string(255)
#  gcj_lat               :decimal(10, 6)
#  gcj_lng               :decimal(10, 6)
#  whole_day             :boolean
#  day_only              :string(255)
#  day_time_begin        :integer
#  day_time_end          :integer
#  day_price             :integer
#  day_first_hour_price  :integer
#  day_second_hour_price :integer
#  night_time_begin      :integer
#  night_time_end        :integer
#  night_price           :integer
#  night_price_hour      :integer
#  times_price           :integer
#  service_month         :boolean
#  month_price           :integer
#  service_wash          :boolean
#  service_wc            :boolean
#  service_repair        :boolean
#  service_rent          :boolean
#  service_rent_company  :boolean
#  service_group         :boolean
#  service_times         :boolean
#  is_recommend          :boolean
#  has_service_coupon    :boolean
#  has_service_point     :boolean
#  is_only_service       :boolean
#  times_price_all_day   :integer
#  tips                  :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

require 'test_helper'

class ParkImportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
