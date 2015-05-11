class CreateParkSpaces < ActiveRecord::Migration
  def change
    create_table :park_spaces do |t|
      t.string :name
      t.string :uuid
      t.integer :park_map_id
      t.integer :park_id
      t.integer :park_map_ele_id
      t.string :usage_status
      t.string :vacancy_status

      t.timestamps
    end
  end
end
