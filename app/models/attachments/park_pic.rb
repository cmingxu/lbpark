# == Schema Information
#
# Table name: attachments_park_pics
#
#  id            :integer          not null, primary key
#  park_pic      :string(255)
#  park_id       :integer
#  original_name :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Attachments::ParkPic < ActiveRecord::Base
  belongs_to :park

  before_save do
    self.original_name = self.park_pic.instance_variable_get("@original_filename")
  end
  mount_uploader :park_pic, ParkPicUploader
end
