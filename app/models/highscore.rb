class HighScore
  def self.update(park_status_or_lottery, quantity = 1, lottery_open = false)
    # 开奖
    if lottery_open && park_status_or_lottery.is_a?(Lottery)
      update_lottery_win(park_status_or_lottery, quantity)

     # 上报
    elsif park_status_or_lottery.is_a?(ParkStatus)
      update_park_status(park_status_or_lottery, quantity)

      # 中彩票
    elsif park_status_or_lottery.is_a?(Lottery)
      update_lottery(park_status_or_lottery, quantity)
    end
  end

  def self.update_lottery_win(lottery, quantity)
    HighScoreBucket.instance("hs#{lottery.open_num}").update lottery.user_id.to_s, quantity
  end

  def self.update_lottery(lottery, quantity)
    day_name = "hs:lottery_count:" + Time.now.strftime("%Y%m%d")
    week_name = "hs:lottery_count:" + Time.now.strftime("%Y%W")
    total_name = "hs:lottery_count"

    HighScoreBucket.instance(day_name).update lottery.user_id.to_s, quantity
    HighScoreBucket.instance(week_name).update lottery.user_id.to_s, quantity
    HighScoreBucket.instance(total_name).update lottery.user_id.to_s, quantity
  end

  def self.update_park_status(lottery, quantity)
    day_name = "ps:park_status_count:" + Time.now.strftime("%Y%m%d")
    week_name = "ps:park_status_lottery_count:" + Time.now.strftime("%Y%W")
    total_name = "ps:park_status_lottery_count"

    HighScoreBucket.instance(day_name).update lottery.user_id.to_s, quantity
    HighScoreBucket.instance(week_name).update lottery.user_id.to_s, quantity
    HighScoreBucket.instance(total_name).update lottery.user_id.to_s, quantity
  end
end


class HighScoreBucket
  attr_accessor :name

  def self.instance(name)
    HighScore.new(name)
  end

  def initialize(name)
    @name = name
  end

  def list
  end

  def remove(key)
  end

  def update(key, new_score)
  end
end
