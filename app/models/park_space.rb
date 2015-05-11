class ParkSpace < ActiveRecord::Base
  belongs_to :park
  belongs_to :park_map
  belongs_to :park_map_ele
end
