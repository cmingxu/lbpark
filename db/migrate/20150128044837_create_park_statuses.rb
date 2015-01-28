class CreateParkStatuses < ActiveRecord::Migration
  def change
    create_table :park_statuses do |t|
      t.string :status
      t.integer :park_id
      t.integer :user_id

      t.timestamps
    end
  end
end
