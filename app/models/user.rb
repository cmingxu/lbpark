# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  token              :string(255)
#  encrypted_password :string(255)
#  phone              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  role               :string(255)
#

class User < ActiveRecord::Base
  # for user with role vendor
  has_many :park_statuses
  has_many :lotteries
  has_many :users_parks
  has_many :parks, :through => :users_parks

  scope :vendors, -> { where(:role => 'vendor') }
  validates :phone, presence: true
  validates :phone, format: { with: /\A(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}\z/ }

  def park
    self.parks.first
  end

  def self.login(phone)
    user = self.find_by_phone(phone)
    return user if user
    create(:phone => phone)
  end

  def vendor?
    self.role == "vendor"
  end
end
