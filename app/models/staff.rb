# == Schema Information
#
# Table name: staffs
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  email              :string(255)
#  phone              :string(255)
#  role               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Staff < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
  attr_accessor :password

  has_many :imports
  serialize :role, Array

  def admin?
    self.role.include? "admin"
  end

  def user?
  end


  def password=(pass)
    self.salt = SecureRandom::hex(10)
    self.encrypted_password = self.class.password_encryption(pass, self.salt)
  end

  def password_valid?(pass)
    self.encrypted_password == self.class.password_encryption(pass, self.salt)
  end

  def self.login(login, pass)
    u = Staff.find_by_email(login)
    return nil if u.nil?

    u.password_valid?(pass) ? u : nil
  end

  def self.password_encryption(pass, salt)
    Digest::SHA1.hexdigest(salt + pass)
  end
end
