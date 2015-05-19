# == Schema Information
#
# Table name: clients
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  email                 :string(255)
#  encrypted_password    :string(255)
#  salt                  :string(255)
#  last_login_at         :datetime
#  last_login_ip         :string(255)
#  park_id               :integer
#  plugins               :text
#  balance               :integer
#  created_at            :datetime
#  updated_at            :datetime
#  phone                 :string(255)
#  login                 :string(255)
#  phone_verified        :string(255)
#  sms_verification_code :string(255)
#

class ClientUser < ActiveRecord::Base
  attr_accessor :password

  belongs_to :client
  validates :login, uniqueness: { :scope => :park_id }, :on => :create

  def password=(pass)
    self.salt = SecureRandom::hex(10)
    self.encrypted_password = self.class.password_encryption(pass, self.salt)
  end

  def password_valid?(pass)
    self.encrypted_password == self.class.password_encryption(pass, self.salt)
  end

  def self.login(login, pass)
    u = ClientUser.find_by_email(login) || ClientUser.find_by_login(login) || ClientUser.find_by_phone(login)
    return nil if u.nil?

    u.password_valid?(pass) ? u : nil
  end

  def self.password_encryption(pass, salt)
    Digest::SHA1.hexdigest(salt + pass)
  end

  def self.auto_generate_login(park)
    park.code
  end

  def self.auto_generate_email(park)
    park.pinyin.gsub(" ", "_") + "_" + SecureRandom.hex(2)
  end

  def send_setup_sms_code
  end

  def self.auto_generate_password(park)
    park.code
  end
end
