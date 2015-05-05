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
#

class ParkMap < ActiveRecord::Base
  belongs_to :park
  belongs_to :user
  has_many :park_map_eles, :dependent => :destroy
end
