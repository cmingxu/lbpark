class ValidDatesToCouponTpls < ActiveRecord::Migration
  def change
    add_column :coupon_tpls, :valid_dates, :string
  end
end
