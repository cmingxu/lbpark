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

class Park < ActiveRecord::Base
  COLUMN_MAP = {
    :lb_staff => "采集人",
    :pic_num => "照片编号",
    :property_owner => "物业联系人/电话",
    :originate_from => "性质",
    :same_as => "属性",
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
    :gcj_lat => "纬度",
    :gcj_lng => "经度",
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
    1 => "紧张",
    2 => "爆满",
    3 => "未知",
    4 => "禁停",
  }
  PARK_TYPE = ["地面", "地下", "桥下", "立体", "院内", "街面", "路边", "辅路"]
  PARK_TYPE_CODE = ["A", "B", "C"]
  PARK_ORIGINATE_FROM = ["公建", "居住", "单位"]

  has_one :owner, :class_name => "ParkOwner"
  has_one :info, :class_name => "ParkInfo"
  has_many :park_statuses, :dependent => :destroy
  has_many :vendors, :class_name => "User"
  has_one :latest_park_status, -> { where('chosen = 1').order("created_at DESC").limit(1) }, :class_name => "ParkStatus"
  has_many :messages, :as => :owner
  has_many :coupons, :dependent => :destroy
  has_many :coupon_tpls, :dependent  => :destroy

  scope :within_range, lambda {|range| where(["gcj_lng > ? AND gcj_lat > ? AND gcj_lng < ? AND gcj_lat <?", range.p1.lng, range.p1.lat, range.p2.lng, range.p2.lat]) }
  scope :rand_visible, lambda {|r| where(["round(rand() * ?) = 1", r])}
  scope :with_park_type_code, ->(code) { where(park_type_code: code) }
  attr_accessor :lat, :lng, :price_calculator

  validates :code, presence: true

  has_many :park_pics, :dependent => :destroy, :class_name => "Attachments::ParkPic"
  has_many :park_instructions, :dependent => :destroy, :class_name => "::Attachments::ParkInstruction"
  has_many :clients, :dependent => :destroy

  accepts_nested_attributes_for :park_instructions, :park_pics, :allow_destroy => true

  after_initialize do
    #self.lat, self.lng = EvilTransform.to_MGS(lat: self.gcj_lat, lon: self.gcj_lng)
    self.lat = self.gcj_lat
    self.lng = self.gcj_lng
    self.price_calculator = PriceCalculator.new(self)
  end

  before_save do
    self.night_time_begin = self.day_time_end
    self.night_time_end   = self.day_time_begin
    self.pinyin           = Pinyin.t(self.name)
  end


  delegate :price_by_day?, :by_month_only?, :day_only?, :desc, :no_parking?, :current_price, :day_price, :day_unit, :night_price, :night_unit, :day_time_range, :night_time_range, :to => "@price_calculator"

  def tags
    park_tags = []
    park_tags << { :name => "次小时#{self.day_second_hour_price.to_i}元起", :link => nil } if self.day_second_hour_price
    if self.total_count && self.total_count.include?("+")
      park_tags << { :name => "总车位#{self.total_count}", :link => nil }
    else
      park_tags << { :name => "总车位#{self.total_count}个", :link => nil }
    end
    park_tags << { :name => "包月#{self.month_price}元起", :link => nil } if self.month_price
    park_tags << { :name => "卫生间", :link => nil } if self.service_wc
    park_tags << { :name => self.service_rent_company, :link => nil } if self.service_rent && self.service_rent_company.present?
    park_tags << { :name => "来洗车", :link => nil } if self.service_wash
    #park_tags << { :name => "修车", :link => nil } if self.service_repair
    park_tags << { :name => "夜间禁停", :link => nil } if self.day_only?
    park_tags << { :name => "仅包月", :link => nil } if self.by_month_only?
    park_tags
  end


  def silblings
    self.class.where("same_as = ?", self.code)
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
      [self.address]
    when "B"
      [self.address, self.tips]
    when "C"
      tips = [self.address]
      tips << (self.price_by_day? ? self.tips : "夜间停车免费")
      if self.day_first_hour_price.present? && self.day_second_hour_price.present? && self.price_by_day?
        tips << "首小时#{self.day_first_hour_price.to_i}元后#{self.day_second_hour_price.to_i}元"
      elsif self.day_first_hour_price.present? && self.price_by_day?
        tips << "每小时#{self.day_first_hour_price.to_i}元"
      elsif self.day_price_per_time.present? && self.price_by_day?
        tips << "每次#{self.day_price_per_time.to_i}元"
      end
      tips
    end.select{|a| a.present? }.join("/")
  end

  def location
    Location.new(self.gcj_lng, self.gcj_lat)
  end

  def park_total_count
    self.total_count.to_i || 0
  end

  class << self
    def bottom_left
      order("gcj_lat ASC, gcj_lng DESC").limit(1).first
    end

    def top_right
      order("gcj_lat DESC, gcj_lng ASC").limit(1).first
    end

    def top_left
      order("gcj_lat DESC, gcj_lng DESC").limit(1).first
    end

    def bottom_right
      order("gcj_lat ASC, gcj_lng ASC").limit(1).first
    end

    def build_heatmap_data
      $redis.ltrim RedisKeyConst.parking_lot_heatmap_data_key, 0, 0
      $redis.ltrim RedisKeyConst.park_slot_heatmap_data_key, 0, 0

      lng_start = order("gcj_lng ASC").limit(1).first.gcj_lng
      lng_end =   order("gcj_lng DESC").limit(1).first.gcj_lng
      lat_tmp = lat_start = order("gcj_lat ASC").limit(1).first.gcj_lat
      lat_end = order("gcj_lat DESC").limit(1).first.gcj_lat

      step = 0.01

      while(lng_start < lng_end) do
        while(lat_tmp < lat_end) do
          parks = with_park_type_code('A').within_range(LbRange.new(Location.new(lng_start, lat_tmp), Location.new(lng_start + step, lat_tmp + step)))
          $redis.lpush RedisKeyConst.parking_lot_heatmap_data_key, "#{lng_start + step/2.0}|#{lat_tmp + step/2.0}|#{parks.count}"
          $redis.lpush RedisKeyConst.park_slot_heatmap_data_key, "#{lng_start + step/2.0}|#{lat_tmp + step/2.0}|#{parks.inject(0){|s, i| s += i.park_total_count; s}}"

          lat_tmp += step
        end
        lat_tmp   = lat_start
        lng_start += step
      end

    end

    def parking_lot_heatmap_data
      datas = $redis.lrange RedisKeyConst.parking_lot_heatmap_data_key, 0, Park.count
      datas.map do |a|
        a.split("|")
      end
    end

    def park_slot_heatmap_data
      datas = $redis.lrange RedisKeyConst.park_slot_heatmap_data_key, 0, Park.count
      datas.map do |a|
        a.split("|")
      end
    end
  end

end
