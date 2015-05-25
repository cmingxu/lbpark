class CreateGates < ActiveRecord::Migration
  def change
    create_table :gates do |t|
      t.string :serial_num
      t.integer :client_id
      t.integer :park_id
      t.boolean :is_in
      t.datetime :last_heartbeat_seen_at
      t.string :version
      t.string :hardware_version

      t.timestamps
    end
  end
end
