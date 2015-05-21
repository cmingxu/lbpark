class ClientMember < ActiveRecord::Base
  has_many :client_memberships
  belongs_to :client
  belongs_to :park
  belongs_to :client_user

  validates :name, presence: true
  validates :phone, presence: true
  validates :paizhao, presence: true

  accepts_nested_attributes_for :client_memberships

  def park_space_name
    self.client_memberships.active.last.try(:park_space).try(:name)
  end

  def current_client_membership
    self.client_memberships.active.last
  end
end
