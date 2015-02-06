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
  has_many :park_statuses
  has_many :users_parks
  has_many :parks, :through => :users_parks

  scope :vendors, -> { where(:role => 'vendor') }

  def self.authenticate!(env)
  end

  def park
    self.parks.first
  end

  def login
  end

  def role
  end
end
