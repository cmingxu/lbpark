class CreateClientMemberships < ActiveRecord::Migration
  def change
    create_table :client_memberships do |t|
      t.integer :client_member_id
      t.integer :order_id
      t.datetime :begin_at
      t.datetime :end_at
      t.integer :month_count
      t.integer :total_price

      t.timestamps
    end
  end
end
