# == Schema Information
#
# Table name: client_memberships
#
#  id               :integer          not null, primary key
#  client_member_id :integer
#  order_id         :integer
#  begin_at         :datetime
#  end_at           :datetime
#  month_count      :integer
#  total_price      :integer
#  created_at       :datetime
#  updated_at       :datetime
#  park_space_id    :integer
#

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
