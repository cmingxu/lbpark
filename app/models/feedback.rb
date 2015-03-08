# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  contact    :string(255)
#  content    :text
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Feedback < ActiveRecord::Base
end
