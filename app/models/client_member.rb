# == Schema Information
#
# Table name: client_members
#
#  id                 :integer          not null, primary key
#  client_id          :integer
#  member_id          :integer
#  client_user_id     :integer
#  source             :string(255)
#  name               :string(255)
#  phone              :string(255)
#  paizhao            :string(255)
#  driver_license_pic :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class ClientMember < ActiveRecord::Base
  has_many :client_memberships
  belongs_to :client
  belongs_to :park
  belongs_to :client_user

  validates :name, presence: true
  validates :phone, presence: true
  validates :paizhao, presence: true

  accepts_nested_attributes_for :client_memberships

  after_save :break_version_cache_for_gate_feature

  def park_space_name
    self.client_memberships.active.last.try(:park_space).try(:name)
  end

  def current_client_membership
    self.client_memberships.active.last
  end

  def membership_valid?
    self.client_memberships.active.exists?
  end

  def valid_membership_json
    membership = self.current_client_membership
    {
      :paizhao => self.paizhao,
      :begin_at => membership.begin_at.to_i,
      :end_at => membership.end_at.to_i
    }
  end

  def break_version_cache_for_gate_feature
    return if !self.client.plugins.map(&:identifier).include?("hardware_gate")
  end

end
