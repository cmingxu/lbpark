# == Schema Information
#
# Table name: user_favorites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  park_id    :integer
#  label      :string(255)
#  lng        :decimal(10, 6)
#  lat        :decimal(10, 6)
#  created_at :datetime
#  updated_at :datetime
#

class UserFavorite < ActiveRecord::Base
end
