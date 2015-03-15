class AddColumnClaimAt < ActiveRecord::Migration
  def change
    add_column :coupons, :claimed_at, :datetime
    add_column :coupons, :fit_for_date, :date
    add_column :coupons, :coupon_tpl_type, :string
  end
end
