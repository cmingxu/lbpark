# == Schema Information
#
# Table name: park_map_eles
#
#  id                :integer          not null, primary key
#  park_map_id       :integer
#  park_id           :integer
#  park_map_ele_type :string(255)
#  ele_desc          :text
#  created_at        :datetime
#  updated_at        :datetime
#

class ParkMapEle < ActiveRecord::Base
  belongs_to :park_map
  has_one :park_space
  belongs_to :park
  serialize  :ele_desc, Hash
end
