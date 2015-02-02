# == Schema Information
#
# Table name: park_statuses
#
#  id         :integer          not null, primary key
#  status     :string(255)
#  park_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class ParkStatus < ActiveRecord::Base
  belongs_to :park
end
