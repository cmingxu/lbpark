# == Schema Information
#
# Table name: imports
#
#  id         :integer          not null, primary key
#  park_type  :string(255)
#  batch_num  :string(255)
#  staff_id   :string(255)
#  note       :text
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Import < ActiveRecord::Base
  has_many :park_imports
  belongs_to :staff

  mount_uploader :imported_csv, ImportedCsvUploader

  state_machine :initial => :uploaded do
    event :import do
      transition :uploaded => :imported
    end

    event :confirm do
      transition :imported => :confirmed
    end

    event :merge do
      transition :confirmed => :merged
    end
  end
end
