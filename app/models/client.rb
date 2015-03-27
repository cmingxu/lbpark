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
end
