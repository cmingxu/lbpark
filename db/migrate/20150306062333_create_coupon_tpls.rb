class CreateCouponTpls < ActiveRecord::Migration
  def change
    create_table :coupon_tpls do |t|
      t.integer :park_id
      t.integer :priority
      t.integer :staff_id
      t.string :type
      t.string :identifier
      t.string :name_cn
      t.date :fit_for_date
      t.datetime :end_at
      t.decimal :gcj_lat, :precision => 10, :scale => 6
      t.decimal :gcj_lng, :precision => 10, :scale => 6
      t.integer :quantity
      t.integer :price
      t.integer :copy_from
      t.string :status
      t.datetime :published_at

      t.timestamps
    end
  end
end
