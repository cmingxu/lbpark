class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.string :name
      t.string :encrypted_password
      t.string :salt
      t.string :email
      t.string :phone
      t.string :role

      t.timestamps
    end
  end
end
