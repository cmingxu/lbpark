class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :order_num
      t.integer :park_id
      t.integer :user_id
      t.string :status
      t.integer :price
      t.integer :coupon_id
      t.datetime :paid_at

      t.timestamps
    end
  end
end
