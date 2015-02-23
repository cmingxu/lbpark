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
#  country        :string(255)
#  headimg        :string(255)
#  subscribe_time :datetime
#  unionid        :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class WechatUser < ActiveRecord::Base
  validates :openid, uniqueness: true

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
      self.create_or_find_by_open_id request[:FromUserName]
    end
  end
end
