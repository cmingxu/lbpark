# == Schema Information
#
# Table name: users_parks
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  park_id    :integer
#  role       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class UsersPark < ActiveRecord::Base
  belongs_to :user
  belongs_to :park
end
