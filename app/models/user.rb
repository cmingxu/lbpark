# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  login                :string(255)
#  email                :string(255)
#  encrypted_password   :string(255)
#  salt                 :string(255)
#  last_login_ip        :string(255)
#  last_login_at        :datetime
#  reset_password_token :string(255)
#  status               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'digest/md5'

class User < ActiveRecord::Base
  validates :email, presence: { :message => "Email不能为空" }
  validates :email, uniqueness: { :message => "Email已经存在， 尝试我们的找回密码功能" }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create, message: "Email格式不正确" }


  after_create :reset_password

  def reset_password
    self.encrypted_password = self.salt = nil
    self.update_column :reset_password_token, SecureRandom.hex(16)
  end


  def self.login(params)
    if user = (self.find_by_email(params[:email]) || self.find_by_name(params[:name]))
      return nil unless user.password_valid?(params[:password])
    end
    user
  end

  def password_valid?(pass)
    self.encrypted_password == Digest::MD5.hexdigest([self.salt, pass].join(":"))
  end
end
