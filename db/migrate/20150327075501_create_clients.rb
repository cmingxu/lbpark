class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.string :salt
      t.datetime :last_login_at
      t.string :last_login_ip
      t.integer :park_id
      t.text :plugins
      t.integer :balance

      t.timestamps
    end
  end
end
