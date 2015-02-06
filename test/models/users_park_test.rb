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

require 'test_helper'

class UsersParkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
