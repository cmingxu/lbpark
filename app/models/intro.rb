class Intro < ActiveRecord::Base
  validates :title, presence: true
  validates :title, uniqueness: true
  validates :desc, presence: true
  validates :content, presence: true
end
