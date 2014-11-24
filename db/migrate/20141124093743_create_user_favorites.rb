class CreateUserFavorites < ActiveRecord::Migration
  def change
    create_table :user_favorites do |t|
      t.integer :user_id
      t.integer :park_id
      t.string :label
      t.decimal :lng
      t.decimal :lat

      t.timestamps
    end
  end
end
