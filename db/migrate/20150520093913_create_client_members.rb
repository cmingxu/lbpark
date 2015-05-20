class CreateClientMembers < ActiveRecord::Migration
  def change
    create_table :client_members do |t|
      t.integer :client_id
      t.integer :member_id
      t.integer :client_user_id
      t.string :source
      t.string :name
      t.string :phone
      t.string :paizhao
      t.string :driver_license_pic

      t.timestamps
    end
  end
end
