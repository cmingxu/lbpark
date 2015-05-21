class ClientMembership < ActiveRecord::Base
  belongs_to :client_member
  belongs_to :order
  belongs_to :park_space

  validates :begin_at, presence: true
  validates :month_count, presence: true
  validates :month_count, numericality: { :greater_than => 0 }
  validates :total_price, presence: true
  validates :total_price, numericality: { :greater_than => 0 }


  before_create do
    self.end_at = self.begin_at + self.month_count.months
  end

  scope :active, -> { where("begin_at < ? AND ? < end_at", Time.now, Time.now) }

end
