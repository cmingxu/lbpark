class Page < ActiveRecord::Base
  validates :title, presence: true
  validates :permalink, presence: true
  validates :content, presence: true
  #validates :permalink, uniqueness: true
end
