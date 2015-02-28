# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  token              :string(255)
#  encrypted_password :string(255)
#  phone              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  role               :string(255)
#

class User < ActiveRecord::Base
  # for user with role vendor
  has_many :park_statuses
  has_many :lotteries
  has_many :users_parks
  has_many :parks, :through => :users_parks
  has_many :wechat_user_activities

  scope :vendors, -> { where(:role => 'vendor') }
  validates :phone, format: { with: /\A(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}\z/ }, :allow_blank => true
  validates :openid, uniqueness: true

  mount_uploader :headimg, WechatUserHeaderImgUploader

  def park
    self.parks.first
  end

  def self.login(phone)
    user = self.find_by_phone(phone)
    return user if user
    create(:phone => phone)
  end

  def self.login_from_wechat(auth_callback, user_type = :vendor)
    user = User.find_or_initialize_by(:openid => auth_callback[:uid])
    info = auth_callback[:info]
    if !user.persisted?
      user.role = user_type
      user.source = :wechat
      user.openid = info[:openid]
      user.nickname = info[:nickname]
      user.language = info[:language]
      user.province = info[:province]
      user.city = info[:city]
      user.sex = info[:sex]
      user.subscribe_time = Time.at(info[:subscribe_time])
    end

    user.last_login_at = Time.now
    user.save ? user : nil
  end

  def replaced_phone
    "#{self.phone[0..3]}****#{self.phone[7..10]}"
  end

  def vendor?
    self.role == "vendor"
  end

  class << self
    def user_subscribe!(request)
      self.find_or_create_by(:openid => request[:FromUserName])
    end

    def user_unsubscribe!(request)
      wu = where(:openid => request[:FromUserName]).first
      wu.unsubscribe!
    end
  end

  def sync_wechat_user!
    user_response = $wechat_api.user(self.openid)
    %w(nickname sex language province country unionid).each do |col|
      self.send("#{col}=", user_response[col])
    end

    self.subscribe_time = Time.at(user_response["subscribe_time"])
    self.headimg = WechatUserHeaderImgUploader.new
    self.headimg.download! user_response["headimgurl"]
    self.save
    self.sync!
  end

end
