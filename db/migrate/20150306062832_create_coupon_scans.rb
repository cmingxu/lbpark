class CreateCouponScans < ActiveRecord::Migration
  def change
    create_table :coupon_scans do |t|
      t.integer :coupon_id
      t.integer :coupon_tpl_id
      t.integer :scan_by_id
      t.decimal :gcj_lat, :precision => 10, :scale => 6
      t.decimal :gcj_lng, :precision => 10, :scale => 6
      t.integer :park_id

      t.timestamps
    end
  end
end
