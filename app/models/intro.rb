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

class Intro < ActiveRecord::Base
  validates :title, presence: true
  validates :title, uniqueness: true
  validates :desc, presence: true
  validates :content, presence: true
end
