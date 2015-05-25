# == Schema Information
#
# Table name: gate_events
#
#  id               :integer          not null, primary key
#  client_id        :integer
#  park_id          :integer
#  gate_id          :integer
#  paizhao          :string(255)
#  client_member_id :integer
#  delay            :boolean
#  happen_at        :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

class GateEvent < ActiveRecord::Base
  belongs_to :client
  belongs_to :park
  belongs_to :gate
end
