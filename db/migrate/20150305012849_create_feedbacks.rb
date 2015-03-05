class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :contact
      t.text :content
      t.string :status

      t.timestamps
    end
  end
end
