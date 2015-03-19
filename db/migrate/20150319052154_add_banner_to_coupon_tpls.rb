class AddBannerToCouponTpls < ActiveRecord::Migration
  def change
    add_column :coupon_tpls, :banner, :string
  end
end
