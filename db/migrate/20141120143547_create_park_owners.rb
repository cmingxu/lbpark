class CreateParkOwners < ActiveRecord::Migration
  def change
    create_table :park_owners do |t|
      t.integer :park_id
      t.decimal :wgs_lat, :precision => 10, :scale => 6
      t.decimal :wgs_lng, :precision => 10, :scale => 6
      t.string :contract
      t.string :contract_phone
      t.string :ownership
      t.string :owner
      t.text :desc
      t.string :maintainer

      t.timestamps
    end
  end
end
