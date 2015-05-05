# == Schema Information
#
# Table name: park_notice_items
#
#  id            :integer          not null, primary key
#  content       :text
#  position      :integer
#  coupon_tpl_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class ParkNoticeItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
