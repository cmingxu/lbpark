class CreateParkMaps < ActiveRecord::Migration
  def change
    create_table :park_maps do |t|
      t.integer :park_id
      t.string :version
      t.datetime :last_edit_at
      t.integer :last_edit_by
      t.string :layer
      t.integer :position

      t.timestamps
    end
  end
end
