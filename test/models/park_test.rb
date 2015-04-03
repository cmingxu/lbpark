# == Schema Information
#
# Table name: parks
#
#  id                       :integer          not null, primary key
#  code                     :string(255)
#  province                 :string(255)
#  city                     :string(255)
#  district                 :string(255)
#  name                     :string(255)
#  address                  :string(255)
#  park_type                :string(255)
#  park_type_code           :string(255)
#  total_count              :string(255)
#  gcj_lat                  :decimal(10, 6)
#  gcj_lng                  :decimal(10, 6)
#  whole_day                :boolean
#  day_only                 :string(255)
#  day_time_begin           :integer
#  day_time_end             :integer
#  day_first_hour_price     :float(24)
#  day_second_hour_price    :float(24)
#  day_price_per_time       :float(24)
#  night_price_per_night    :float(24)
#  night_price_per_hour     :float(24)
#  whole_day_price_per_time :float(24)
#  whole_day_price_per_hour :float(24)
#  night_time_begin         :integer
#  night_time_end           :integer
#  service_month            :boolean
#  month_price              :integer
#  service_wash             :boolean
#  service_wc               :boolean
#  service_repair           :boolean
#  service_rent             :boolean
#  service_rent_company     :string(255)
#  service_group            :boolean
#  service_times            :boolean
#  is_recommend             :boolean
#  has_service_coupon       :boolean
#  has_service_point        :boolean
#  is_only_service          :boolean
#  tips                     :string(255)
#  lb_staff                 :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  pic_num                  :string(255)
#  originate_from           :string(255)
#  property_owner           :string(255)
#  previews                 :text
#  pinyin                   :string(255)
#  same_as                  :string(255)
#

require 'test_helper'

class ParkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
