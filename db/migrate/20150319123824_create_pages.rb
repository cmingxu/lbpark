class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.string :content_type
      t.integer :edit_by
      t.string :permalink

      t.timestamps
    end
  end
end
