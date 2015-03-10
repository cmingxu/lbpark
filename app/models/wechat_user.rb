# == Schema Information
#
# Table name: wechat_users
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  status         :string(255)
#  openid         :string(255)
#  nickname       :string(255)
#  sex            :integer
#  language       :string(255)
#  province       :string(255)
#  city           :string(255)
#  country        :string(255)
#  headimg        :string(255)
#  remark         :text
#  subscribe_time :datetime
#  unionid        :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class WechatUser < ActiveRecord::Base
  validates :openid, uniqueness: true
  after_commit :sync_wechat_user_event, :on => :create

  has_many :wechat_user_activities

  mount_uploader :headimg, WechatUserHeaderImgUploader

  state_machine :status, :initial => :subscribed do
    event :sync do
      transition :subscribed => :synced
    end

    event :unsubscribe do
      transition all => :unsubscribed
    end
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

  def sync_wechat_user_event
    Resque.enqueue_at Time.now + 30, SyncWechatUser, self.id
  end

  def sync_wechat_user!
    if User.find_by_openid(self.openid).role == "vendor"
      user_response = $vendor_wechat_api.user(self.openid)
    else
      user_response = $wechat_api.user(self.openid)
    end

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
