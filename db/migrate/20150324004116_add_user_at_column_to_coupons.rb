class AddUserAtColumnToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :used_at, :datetime
  end
end
