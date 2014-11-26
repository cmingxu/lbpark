class CreateIntros < ActiveRecord::Migration
  def change
    create_table :intros do |t|
      t.text :content
      t.text :desc
      t.string :title
      t.string :status
      t.integer :created_by

      t.timestamps
    end
  end
end
