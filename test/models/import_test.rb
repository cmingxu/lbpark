# == Schema Information
#
# Table name: imports
#
#  id         :integer          not null, primary key
#  park_type  :string(255)
#  batch_num  :string(255)
#  staff_id   :string(255)
#  note       :text
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ImportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
