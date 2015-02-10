class Lottery < ActiveRecord::Base
  belongs_to :user
  belongs_to :park
  belongs_to :park_status

  state_machine :status, :initial => :generated do
    event :buy do
      transition :generated => :bought
    end

    event :win do
      transition :bought => :won
    end

    event :lose do
      transition  :bought => :lost
    end
  end
end
