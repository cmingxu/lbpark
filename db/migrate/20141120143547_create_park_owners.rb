class CreateParkOwners < ActiveRecord::Migration
  def change
    create_table :park_owners do |t|
      t.integer :park_id
      t.decimal :wgs_lat
      t.decimal :wgs_lng
      t.string :contract
      t.string :contract_phone
      t.string :ownership
      t.string :owner
      t.text :desc
      t.string :maitainer

      t.timestamps
    end
  end
end
