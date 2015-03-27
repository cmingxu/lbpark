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

class Page < ActiveRecord::Base
  validates :title, presence: true
  validates :permalink, presence: true
  validates :content, presence: true
  #validates :permalink, uniqueness: true
end
