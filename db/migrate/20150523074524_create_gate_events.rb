class CreateGateEvents < ActiveRecord::Migration
  def change
    create_table :gate_events do |t|
      t.integer :client_id
      t.integer :park_id
      t.integer :gate_id
      t.string :paizhao
      t.integer :client_member_id
      t.boolean :delay
      t.datetime :happen_at

      t.timestamps
    end
  end
end
