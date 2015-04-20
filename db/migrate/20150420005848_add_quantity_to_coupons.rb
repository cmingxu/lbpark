class AddQuantityToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :quantity, :integer
  end
end
