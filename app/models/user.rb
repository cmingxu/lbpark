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
#

class User < ActiveRecord::Base
  def self.authenticate!(env)
  end

  def login
  end
end
