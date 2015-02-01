class Staff < ActiveRecord::Base
  validates :name, presence: true

  def password_valid?(pass)
  end

  def self.encrypt_password(pass)
  end

  def self.login(login, pass)
  end
end
