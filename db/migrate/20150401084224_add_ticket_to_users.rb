class AddTicketToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ticket, :string
    add_column :wechat_users, :ticket, :string
  end
end
