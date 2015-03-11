class HighScore
  HIHGSCORE_LIST = {
    :day_lottery_count => "本日奖票最多",
    :day_park_status_count => "本日上报最多",
    :open_lottery_win => "本期中奖最多",
    :week_lottery_count => "本周中奖票最多",
    :week_park_status_count => "本周上报最多",
    :lottery_count => "历史中奖票最多",
    :lottery_win => "历史中奖最多",
    :park_status_count => "历史上报最多"
  }

  class << self
    def day_lottery_count
      HighScoreBucket.new("hs:lottery_count:" + Time.now.strftime("%Y%m%d")).list.map do |item|
        OpenStruct.new(:score => item[1], :name => User.find_by_id(item[0]).nickname)
      end
    end

    def day_park_status_count
      HighScoreBucket.new("ps:park_status_count:" + Time.now.strftime("%Y%m%d")).list.map do |item|
        OpenStruct.new(:score => item[1], :name => User.find_by_id(item[0]).nickname)
      end
    end

    def open_lottery_win
      HighScoreBucket.new("ps:park_status_count:" + Time.now.strftime("%Y%m%d")).list.map do |item|
        OpenStruct.new(:score => item[1], :name => User.find_by_id(item[0]).nickname)
      end
    end

    def week_lottery_count
      HighScoreBucket.new("ps:park_status_count:" + Time.now.strftime("%Y%m%d")).list.map do |item|
        OpenStruct.new(:score => item[1], :name => User.find_by_id(item[0]).nickname)
      end
    end

    def week_park_status_count
      HighScoreBucket.new("ps:park_status_count:" + Time.now.strftime("%Y%m%d")).list.map do |item|
        OpenStruct.new(:score => item[1], :name => User.find_by_id(item[0]).nickname)
      end
    end

    def lottery_count
      HighScoreBucket.new("ps:park_status_count:" + Time.now.strftime("%Y%m%d")).list.map do |item|
        OpenStruct.new(:score => item[1], :name => User.find_by_id(item[0]).nickname)
      end
    end

    def lottery_win
      HighScoreBucket.new("ps:park_status_count:" + Time.now.strftime("%Y%m%d")).list.map do |item|
        OpenStruct.new(:score => item[1], :name => User.find_by_id(item[0]).nickname)
      end
    end

    def park_status_count
      HighScoreBucket.new("ps:park_status_count:" + Time.now.strftime("%Y%m%d")).list.map do |item|
        OpenStruct.new(:score => item[1], :name => User.find_by_id(item[0]).nickname)
      end
    end
  end

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
    HighScoreBucket.instance("hs:lottery_win:#{lottery.open_num}").update lottery.user_id.to_s, quantity
    HighScoreBucket.instance("hs:lottery_win").update lottery.user_id.to_s, quantity
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
    HighScoreBucket.new(name)
  end

  def initialize(name)
    @name = name
  end

  def list
    $redis.zrevrange @name, 0, 100, :with_scores => true
  end

  def remove(key)
    $redis.rem @name, key
  end

  def update(key, new_score)
    $redis.zincrby @name, new_score, key
  end
end


