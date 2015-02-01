class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :park_type
      t.string :batch_num
      t.string :staff_id
      t.desc :note
      t.string :status

      t.timestamps
    end
  end
end
