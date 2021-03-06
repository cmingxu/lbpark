# == Schema Information
#
# Table name: park_maps
#
#  id           :integer          not null, primary key
#  park_id      :integer
#  version      :string(255)
#  last_edit_at :datetime
#  last_edit_by :integer
#  layer        :string(255)
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  name         :string(255)
#

class ParkMap < ActiveRecord::Base
  belongs_to :park
  belongs_to :user
  has_many :park_map_eles, :dependent => :destroy
  has_many :park_spaces

  def as_api_json
    self.park_map_eles.map do |ele|
      {
        :name => ele.park_map_ele_type,
        :prop_list => ele.ele_desc,
        :uuid => ele.uuid,
        :park_space_name => ele.park_space.try(:name)
      }
    end
  end
end
