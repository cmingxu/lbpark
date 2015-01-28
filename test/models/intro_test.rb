# == Schema Information
#
# Table name: intros
#
#  id         :integer          not null, primary key
#  content    :text
#  desc       :text
#  title      :string(255)
#  status     :string(255)
#  created_by :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class IntroTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
