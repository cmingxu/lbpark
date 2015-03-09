class AddColumnToVendorTable < ActiveRecord::Migration
  def change
    add_column :users, :scan_coupon, :boolean
  end
end
