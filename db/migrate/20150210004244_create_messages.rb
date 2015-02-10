class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :owner_id
      t.string :owner_type
      t.text :content

      t.timestamps
    end
  end
end
