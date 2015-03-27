# == Schema Information
#
# Table name: pages
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  content      :text
#  content_type :string(255)
#  edit_by      :integer
#  permalink    :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class PageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
