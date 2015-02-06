# == Schema Information
#
# Table name: attachments_park_instructions
#
#  id                :integer          not null, primary key
#  park_instructions :string(255)
#  park_id           :integer
#  original_name     :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class Attachments::ParkInstruction < ActiveRecord::Base
  belongs_to :park
  before_save do
    self.original_name = self.park_instructions.instance_variable_get("@original_filename")
  end
  mount_uploader :park_instructions, ParkInstructionUploader
end
