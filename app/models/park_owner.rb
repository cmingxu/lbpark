# == Schema Information
#
# Table name: park_owners
#
#  id             :integer          not null, primary key
#  park_id        :integer
#  wgs_lat        :integer
#  wgs_lng        :integer
#  contract       :string(255)
#  contract_phone :string(255)
#  ownership      :string(255)
#  owner          :string(255)
#  desc           :text
#  maitainer      :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class ParkOwner < ActiveRecord::Base
end
