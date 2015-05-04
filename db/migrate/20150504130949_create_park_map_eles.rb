class CreateParkMapEles < ActiveRecord::Migration
  def change
    create_table :park_map_eles do |t|
      t.integer :park_map_id
      t.integer :park_id
      t.string :park_map_ele_type
      t.text :ele_desc

      t.timestamps
    end
  end
end
