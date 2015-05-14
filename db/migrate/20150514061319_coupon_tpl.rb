class CouponTpl < ActiveRecord::Migration
  def change
    add_column :coupon_tpls, :park_space_choose_enabled, :boolean
  end
end
