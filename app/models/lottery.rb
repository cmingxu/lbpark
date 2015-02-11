# == Schema Information
#
# Table name: lotteries
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  open_num       :string(255)
#  serial_num     :string(255)
#  park_status_id :integer
#  park_id        :integer
#  phone          :string(255)
#  open_at        :datetime
#  notes          :text
#  win            :boolean
#  win_amount     :integer
#  status         :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Lottery < ActiveRecord::Base
  belongs_to :user
  belongs_to :park
  belongs_to :park_status

  state_machine :status, :initial => :generated do
    event :buy do
      transition :generated => :bought
    end

    event :win do
      transition :bought => :won
    end

    event :lose do
      transition  :bought => :lost
    end
  end

  def self.spin!(park_status)
    return if rand(100) < Settings.lottery_ratio
    create do |l|
      l.park_status_id = park_status.id
      l.open_num = next_open_num
      l.serial_num = random_serial_num
      l.park_id = park_status.park_id
      l.phone = park_status.user.phone
      l.user = park_status.user
    end
  end

  def self.random_serial_num
    6.times.map do
      sprintf("%02d", rand(33) + 1)
    end.tap do |arr|
      arr << rand(16) + 1
    end.join " "
  end

  # 确保有时间买彩票
  def self.next_open_num(offset = Time.now)
    time_iterator = Time.now.beginning_of_year

    open_num = 0
    while time_iterator < offset do
      if [2,4,0].include?(time_iterator.wday)
        open_num += 1
      end
      time_iterator = time_iterator += 1.day
    end

    open_num += 1

    "#{offset.year}#{sprintf('%03d', open_num)}"
  end
end
