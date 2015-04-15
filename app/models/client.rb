# == Schema Information
#
# Table name: clients
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  last_login_at      :datetime
#  last_login_ip      :string(255)
#  park_id            :integer
#  plugins            :text
#  balance            :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class Client < ActiveRecord::Base
  #validates :name, presence: true
  #validates :name, uniqueness: true
  attr_accessor :password

  belongs_to :park
  validates :email, uniqueness: { :scope => :park_id }

  def password=(pass)
    self.salt = SecureRandom::hex(10)
    self.encrypted_password = self.class.password_encryption(pass, self.salt)
  end

  def password_valid?(pass)
    self.encrypted_password == self.class.password_encryption(pass, self.salt)
  end

  def self.login(login, pass)
    u = Client.find_by_email(login)
    return nil if u.nil?

    u.password_valid?(pass) ? u : nil
  end

  def self.password_encryption(pass, salt)
    Digest::SHA1.hexdigest(salt + pass)
  end

  def self.auto_generate_email(park)
    park.pinyin.gsub(" ", "_") + "_" + SecureRandom.hex(2)
  end

  def self.auto_generate_password(park)
    sprintf("%06d", rand(100000))
  end

  def plugins
    Plugin::Base.subclasses.map do |p|
      p.new self
    end
  end
end
