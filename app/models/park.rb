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
  COLUMN_MAP = {
    :tips => "备注",
    :times_price_all_day => "全天按次价",
    :is_only_service => "",
    :is_recommend => "推荐",
    :service_times => "",
    :service_group => "",
    :service_rent_company => "租车公司",
    :service_rent => "租车",
    :service_repair => "修车",
    :service_wc => "厕所",
    :service_wash => "洗车",
    :day_second_hour_price => "白天第二小时价格",
    :day_first_hour_price => "白天第一小时价",
    :day_price_per_time => "白天按次",
    :night_price_per_hour => "夜间按时",
    :night_price_per_night => "夜间按夜",
    :whole_day_price_per_time => "全天按次",
    :whole_day_price_per_hour => "全天按时",
    :month_price => "包月价格",
    :night_time_end => "夜间结束",
    :night_time_begin => "夜间开始",
    :day_time_end => "白天结束",
    :day_time_begin => "白天开始",
    :day_only => "仅白天",
    :whole_day => "全天",
    :gcj_lat => "经度",
    :gcj_lng => "纬度",
    :total_count => "车位数",
    :park_type_code => "类型CODE",
    :park_type => "类型",
    :address => "地址",
    :name => "名称",
    :district => "区域",
    :city => "城市",
    :province => "省",
    :code => "编号"
  }
  BUSY_STATUS = {
    :green => 0,
    :orange => 1,
    :red => 2,
    :unknown => 3
  }
  PARK_TYPE = ["地面", "地下", "桥下", "立体", "院内", "街面", "路边", "辅路"]
  PARK_TYPE_CODE = ["A", "B", "C"]

  has_one :owner, :class_name => "ParkOwner"
  has_one :info, :class_name => "ParkInfo"
  has_many :park_statuses
  has_many :vendors, :class_name => "User"
  has_one :latest_park_status, -> { order("created_at DESC").limit(1) }, :class_name => "ParkStatus"

  scope :within_range, lambda {|range| where(["gcj_lng > ? AND gcj_lat > ? AND gcj_lng < ? AND gcj_lat <?", range.p1.lng, range.p1.lat, range.p2.lng, range.p2.lat]).limit(200) }
  scope :with_park_type_code, ->(code) { where(park_type_code: code) }
  attr_accessor :lat, :lng

  after_initialize do
    #self.lat, self.lng = EvilTransform.to_MGS(lat: self.gcj_lat, lon: self.gcj_lng)
    self.lat = self.gcj_lat
    self.lng = self.gcj_lng
  end

  def tags
    park_tags = [ { :name => "总车位#{self.total_count}个", :link => nil } ]
    park_tags << { :name => "包月#{self.month_price}起", :link => nil } if self.service_month
    park_tags << { :name => "卫生间", :link => nil } if self.service_wc
    park_tags << { :name => self.service_rent_company, :link => nil } if self.service_rent
    park_tags << { :name => "洗车", :link => nil } if self.service_wash
    park_tags << { :name => "修车", :link => nil } if self.service_repair
    park_tags
  end

  def calculated_day_price
    self.day_price
  end

  def day_time_range
    "07:00 - 21:00"
  end

  def calculated_night_price
    self.night_price
  end

  def night_time_range
    "21:00 - 07:00"
  end

  def day_price_unit
    "时"
  end

  def night_price_unit
    "时"
  end

  def use_day_price?
    Time.now.hour >= self.day_time_begin && Time.now.hour < self.day_time_end
  end

  def current_price
    self.use_day_price? ? self.day_price_per_time : self.night_price_per_night
  end

  def busy_status
    (($redis.get RedisKey.park_status_key(self)) || 3).to_i
  end

  def lb_desc
    case self.park_type_code
    when "A"
      self.park_type
    when "B"
      [self.park_type, self.tips].select{|a| a.present? }.join("/")
    when "C"
      [self.park_type, self.tips].select{|a| a.present? }.join("/")

    end
  end
end
