class AddColumn < ActiveRecord::Migration
  def change
    add_column :clients, :phone_verified, :boolean
    add_column :clients, :sms_verification_code, :string
    add_column :clients, :password_changed, :boolean
  end
end
