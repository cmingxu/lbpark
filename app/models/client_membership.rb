class ClientMembership < ActiveRecord::Base
  belongs_to :client_member
  belongs_to :order

  validates :begin_at, presence: true
end
