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

  after_commit do
    create_relevent_park_space
  end

  before_destroy do
    destroy_relelvent_park_space
  end

  def create_relevent_park_space
    return unless self.park_map_ele_type == "park_space"
    return if ParkSpace.find_by(:uuid => self.uuid)
    ParkSpace.create_from_park_map_ele(self)
  end

  def destroy_relelvent_park_space
    return unless self.park_map_ele_type == "park_space"
    self.park_space.try(:destroy)
  end
end
