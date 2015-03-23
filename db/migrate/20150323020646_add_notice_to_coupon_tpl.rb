class AddNoticeToCouponTpl < ActiveRecord::Migration
  def change
    add_column :coupon_tpls, :notice, :string
  end
end
