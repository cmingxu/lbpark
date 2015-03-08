# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  contact    :string(255)
#  content    :text
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
