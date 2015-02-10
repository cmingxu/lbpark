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
#

class Park < ActiveRecord::Base
  COLUMN_MAP = {
    :lb_staff => "采集人",
    :pic_num => "照片编号",
    :property_owner => "物业联系人/电话",
    :originate_from => "性质",
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
    :service_month => "包月",
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
    :unknown => 3,
    :no_parking => 4
  }

  BUSY_STATUS_IN_ZH = {
    0 => "空闲",
    1 => "繁忙",
    2 => "紧张",
    3 => "未知",
    4 => "禁停",
  }
  PARK_TYPE = ["地面", "地下", "桥下", "立体", "院内", "街面", "路边", "辅路"]
  PARK_TYPE_CODE = ["A", "B", "C"]
  PARK_ORIGINATE_FROM = ["公建", "居住", "单位"]

  has_one :owner, :class_name => "ParkOwner"
  has_one :info, :class_name => "ParkInfo"
  has_many :park_statuses
  has_many :vendors, :class_name => "User"
  has_one :latest_park_status, -> { where('chosen = 1').order("created_at DESC").limit(1) }, :class_name => "ParkStatus"
  has_many :messages, :as => :owner

  scope :within_range, lambda {|range| where(["gcj_lng > ? AND gcj_lat > ? AND gcj_lng < ? AND gcj_lat <?", range.p1.lng, range.p1.lat, range.p2.lng, range.p2.lat]).limit(200) }
  scope :with_park_type_code, ->(code) { where(park_type_code: code) }
  attr_accessor :lat, :lng, :price_calculator

  validates :code, presence: true

  has_many :park_pics, :dependent => :destroy, :class_name => "Attachments::ParkPic"
  has_many :park_instructions, :dependent => :destroy, :class_name => "::Attachments::ParkInstruction"

  accepts_nested_attributes_for :park_instructions, :park_pics, :allow_destroy => true

  after_initialize do
    #self.lat, self.lng = EvilTransform.to_MGS(lat: self.gcj_lat, lon: self.gcj_lng)
    self.lat = self.gcj_lat
    self.lng = self.gcj_lng
    self.price_calculator = PriceCalculator.new(self)
  end

  delegate :no_parking?, :current_price, :day_price, :day_unit, :night_price, :night_unit, :day_time_range, :night_time_range, :to => "@price_calculator"

  def tags
    park_tags = [ { :name => "总车位#{self.total_count}个", :link => nil } ]
    park_tags << { :name => "包月#{self.month_price}起", :link => nil } if self.service_month
    park_tags << { :name => "卫生间", :link => nil } if self.service_wc
    park_tags << { :name => self.service_rent_company, :link => nil } if self.service_rent
    park_tags << { :name => "洗车", :link => nil } if self.service_wash
    park_tags << { :name => "修车", :link => nil } if self.service_repair
    park_tags
  end

  def busy_status
    return BUSY_STATUS[:no_parking] if no_parking?
    (($redis.get RedisKey.park_status_key(self)) || BUSY_STATUS[:unknown]).to_i
  end

  def thump_pic_url
    self.park_pics.present? ? self.park_pics.first.park_pic.thumb.url : ""
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

  def location
    Location.new(self.gcj_lng, self.gcj_lat)
  end
end
