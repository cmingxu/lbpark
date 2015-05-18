# == Schema Information
#
# Table name: park_spaces
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  uuid            :string(255)
#  park_map_id     :integer
#  park_id         :integer
#  park_map_ele_id :integer
#  usage_status    :string(255)
#  vacancy_status  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class ParkSpace < ActiveRecord::Base
  USAGE_STATUS = {:long => "长租", :temp => "短租", :for_booking => "预约", :reserved => "内部"}
  VACANCY_STATUS = {:vacancy => "空", :occupied => "占用"}

  belongs_to :park
  belongs_to :park_map
  belongs_to :park_map_ele

  def self.create_from_park_map_ele(park_map_ele)
    return unless park_map_ele.park_map_ele_type == "park_space"
    create do |ps|
      ps.park_map_id = park_map_ele.park_map_id
      ps.park_id     = park_map_ele.park_map.park_id
      ps.uuid        = park_map_ele.uuid
      ps.park_map_ele_id = park_map_ele.id
      ps.usage_status = USAGE_STATUS.keys.first
      ps.vacancy_status = VACANCY_STATUS.keys.first
    end
  end
end
