class AddColumnsToLotteries < ActiveRecord::Migration
  def change
    add_column :lotteries, :lucky_num, :string
    add_column :lotteries, :red_lucky_num_hits, :integer
    add_column :lotteries, :blue_ball_hit, :boolean
    add_column :lotteries, :money_get, :integer
  end
end
