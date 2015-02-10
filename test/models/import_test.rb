# == Schema Information
#
# Table name: imports
#
#  id            :integer          not null, primary key
#  park_type     :string(255)
#  batch_num     :string(255)
#  staff_id      :string(255)
#  note          :text
#  status        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  imported_csv  :string(255)
#  code_prefix   :string(255)
#  city          :string(255)
#  district      :string(255)
#  lb_staff      :string(255)
#  failed_reason :string(255)
#

require 'test_helper'

class ImportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
