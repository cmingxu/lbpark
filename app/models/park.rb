# == Schema Information
#
# Table name: parks
#
#  id                    :integer          not null, primary key
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

class Park < ActiveRecord::Base
  BUSY_STATUS = {
    :green => 0,
    :orange => 1,
    :red => 2,
    :unknown => 3
  }
  has_one :owner, :class_name => "ParkOwner"
  has_one :info, :class_name => "ParkInfo"
  has_many :park_statuses
  has_one :latest_park_status, -> { order("created_at DESC").limit(1) }, :class_name => "ParkStatus"

  scope :within_range, lambda {|range| where(["gcj_lng > ? AND gcj_lat > ? AND gcj_lng < ? AND gcj_lat <?", range.p1.lng, range.p1.lat, range.p2.lng, range.p2.lat]).limit(200) }
  scope :with_park_type_code, ->(code) { where(park_type_code: code) }
  attr_accessor :lat, :lng

  after_initialize do
    #self.lat, self.lng = EvilTransform.to_MGS(lat: self.gcj_lat, lon: self.gcj_lng)
    self.lat = self.gcj_lat
    self.lng = self.gcj_lng
  end

  def current_price
    self.day_price
  end

  def tags
    park_tags = [ {:name => "总车位#{self.total_count}个", :link => nil} ]
    park_tags << {:name => "包月#{self.month_price}起", :link => nil} if self.service_month
    park_tags << {:name => "卫生间", :link => nil} if self.service_wc
    park_tags << {:name => self.service_rent_company, :link => nil} if self.service_rent
    park_tags << {:name => "洗车", :link => nil} if self.service_wash
    park_tags << {:name => "修车", :link => nil} if self.service_repair
    park_tags
  end
end
