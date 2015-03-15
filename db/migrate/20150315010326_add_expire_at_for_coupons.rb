class AddExpireAtForCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :expire_at, :datetime
  end
end
