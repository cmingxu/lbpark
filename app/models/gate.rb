# == Schema Information
#
# Table name: gates
#
#  id                     :integer          not null, primary key
#  serial_num             :string(255)
#  client_id              :integer
#  park_id                :integer
#  is_in                  :boolean
#  last_heartbeat_seen_at :datetime
#  version                :string(255)
#  hardware_version       :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class Gate < ActiveRecord::Base
  validates :serial_num, presence: true
  validates :hardware_version, presence: true
  validates :name, presence: true

  has_many :gate_events
  belongs_to :client
  belongs_to :park
end
