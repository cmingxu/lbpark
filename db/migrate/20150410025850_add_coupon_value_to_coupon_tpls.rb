class AddCouponValueToCouponTpls < ActiveRecord::Migration
  def change
    add_column :coupon_tpls, :coupon_value, :integer
  end
end
