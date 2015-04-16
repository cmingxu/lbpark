class AddColumnToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :body, :string
    add_column :orders, :spbill_create_ip, :string
    add_column :orders, :notify_url, :string
    add_column :orders, :bank_type, :string
    add_column :orders, :transaction_id, :string
  end
end
