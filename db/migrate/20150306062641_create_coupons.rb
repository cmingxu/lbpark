class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.integer :park_id
      t.integer :coupon_tpl_id
      t.string :identifier
      t.integer :user_id
      t.string :status
      t.datetime :end_at
      t.integer :price
      t.string :issued_address

      t.timestamps
    end
  end
end
