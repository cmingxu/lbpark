# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  owner_id   :integer
#  owner_type :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
