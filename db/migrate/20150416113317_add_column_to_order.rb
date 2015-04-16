class AddColumnToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :ip, :string
  end
end
