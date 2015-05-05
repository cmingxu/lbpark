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

class ParkNoticeItem < ActiveRecord::Base
  belongs_to :coupon_tpl
  belongs_to :park
  validates :content, presence: true
  acts_as_list scope: :coupon_tpl
end
