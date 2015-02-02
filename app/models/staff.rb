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

  def password_valid?(pass)
  end

  def self.encrypt_password(pass)
  end

  def self.login(login, pass)
  end
end
