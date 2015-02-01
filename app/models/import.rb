class Import < ActiveRecord::Base
  has_many :park_imports
  belongs_to :staff

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
