class AddHighScoreSwitchToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_check_high_score, :boolean, :default => 0
  end
end
