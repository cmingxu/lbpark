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
  STATUS_MAP = {
    :generated => "未开",
    :bought    => "未开",
    :won       => "中奖",
    :lost       => "未中",
    :paid       => "萝卜已支付"
  }

  STATUS_MAP_COLOR = {
    :generated => "#fbb15c",
    :bought    => "#fbb15c",
    :won       => "#6cd597",
    :lost       => "#528de7",
    :paid       => "#6cd597"
  }

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

    event :pay do
      transition  :won => :paid
    end
  end

  def self.spin!(park_status)
    return if park_status.park.park_statuses.count < 10 && rand(100) < Settings.lottery_ratio
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
    time_iterator = Time.new(2015, 2, 26)
    open_num = 21
    while time_iterator < offset do
      if [2,4,0].include?(time_iterator.wday)
        open_num += 1
      end
      time_iterator = time_iterator += 1.day
    end

    open_num += 1

    "#{offset.year}#{sprintf('%03d', open_num)}"
  end

  def serial_num_human
    s = self.serial_num
    s[s.rindex(" ")] = "/"
    red, blue = s.split("/")
    "<span style='color: red;'>#{red}</span>/" +
    "<span style='color: blue;'>#{blue}</span>"
  end
end
