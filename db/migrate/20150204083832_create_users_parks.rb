class CreateUsersParks < ActiveRecord::Migration
  def change
    create_table :users_parks do |t|
      t.integer :user_id
      t.integer :park_id
      t.string :role

      t.timestamps
    end
  end
end
