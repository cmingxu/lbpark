class AddColumnToLotteries < ActiveRecord::Migration
  def change
    add_column :lotteries, :why, :string
  end
end
