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
    t, reason = get_lotteries_count(park_status)
    t.times do
      lottery = create do |l|
        l.park_status_id = park_status.id
        l.open_num = next_open_num
        l.serial_num = random_serial_num
        l.park_id = park_status.park_id
        l.phone = park_status.user.phone
        l.user = park_status.user
        l.why = reason
      end
      HighScore.update(lottery, t)

    end

    if t > 0
      park_status.park.messages.create do |m|
        m.content = "#{park_status.user.replaced_phone}得到奖票#{t}注"
      end
    end
  end

  def self.get_lotteries_count(park_status)
    # 登录奖励
    return [1, "每日第一次上报"] if park_status.user.park_statuses.where(["created_at <= ? AND created_at > ?", Time.now.end_of_day, Time.now.beginning_of_day]).count == 1
    return [0, ""] unless park_status.chosen
    return [1, "上报次数少于10次"] if park_status.park.park_statuses.count <= 10
    return [1, "正常上报"] if rand(100) < Settings.lottery_ratio
    [0, ""]
  end

  def self.random_serial_num
    (1..33).to_a.shuffle[0..5].map do |i|
      sprintf("%02d", i)
    end.tap do |arr|
      arr << rand(16) + 1
    end.join " "
  end

  def self.open(open_num, lucky_nums)
    raise Exception.new("Lucky num not valid") if lucky_nums.length != 7

    blue_ball = lucky_nums.last
    red_balls = lucky_nums[0..5]

    where(:open_num => open_num, :status => :bought).each do |s|
      int_lucky_nums = s.serial_num.split(" ").map(&:to_i)
      s.lucky_num = lucky_nums.join " "
      s.blue_ball_hit = blue_ball == int_lucky_nums.last
      s.red_lucky_num_hits = (red_balls & int_lucky_nums[0..5]).length
      s.money_get = lucky_money_get(s.red_lucky_num_hits, s.blue_ball_hit ? 1 : 0)
      s.save
      s.money_get.zero? ? s.lose! : s.win!
      s.park_status.park.messages.create do
        |c| c.content = "#{s.user.replaced_phone} #{s.open_num} 中#{s.money_get}元"
      end if !s.money_get.zero?
      HighScore.update(s, s.money_get, true) if s.money_get != 0
    end
  end

  def self.lucky_money_get(red, blue)
    if [0, 1, 2].include?(red) && blue == 1
      5
    elsif 4 == red && blue == 0
      10
    elsif 3 == red && blue == 1
      10
    elsif 4 == red && blue == 1
      200
    elsif 5 == red && blue == 0
      200
    elsif 6 == red && blue == 0
      1000000000
    elsif 6 == red && blue == 1
      1000000000
    else
      0
    end
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
