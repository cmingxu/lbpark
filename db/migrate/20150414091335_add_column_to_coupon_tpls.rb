class AddColumnToCouponTpls < ActiveRecord::Migration
  def change
    add_column :coupon_tpls, :valid_hour_begin, :integer
    add_column :coupon_tpls, :valid_hour_end, :integer
    add_column :coupon_tpls, :lower_limit_for_deduct, :integer
  end
end
