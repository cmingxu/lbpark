# == Schema Information
#
# Table name: imports
#
#  id            :integer          not null, primary key
#  park_type     :string(255)
#  batch_num     :string(255)
#  staff_id      :string(255)
#  note          :text
#  status        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  imported_csv  :string(255)
#  code_prefix   :string(255)
#  city          :string(255)
#  district      :string(255)
#  lb_staff      :string(255)
#  failed_reason :string(255)
#

class Import < ActiveRecord::Base
  STATUS = {
    :uploaded => "刚刚上传",
    :imported => "导入",
    :confirmed => "确认",
    :merged => "合并"

  }
  has_many :park_imports, :dependent => :destroy
  belongs_to :staff

  after_create do
    self.import_park_imports
  end

  mount_uploader :imported_csv, ImportedCsvUploader

  state_machine :status, :initial => :uploaded do
    after_transition :on => :start_merge, :do => :the_merge

    event :import do
      transition :uploaded => :imported
    end

    event :import_failed do
      transition :uploaded => :failed
    end

    event :start_merge do
      transition :imported => :merged
    end
  end

  def the_merge
    self.park_imports.each do |pi|
      pi.do_the_merge!
    end
  end

  def import_park_imports
    begin
      Xls2db.send("import_#{self.park_type.downcase}", self.imported_csv.file.path, ParkImport, self)
      self.lb_staff = self.park_imports.first.lb_staff
      self.city = self.park_imports.first.city
      self.district = self.park_imports.first.district
      save
      self.import!

    rescue ImportException => e
      self.update_column :failed_reason, e.message
      self.import_failed!
    rescue Exception => e
      self.update_column :failed_reason, e.message
      self.import_failed!
    end
  end
end
