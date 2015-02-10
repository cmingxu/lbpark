class AddUserIdToSmsCode < ActiveRecord::Migration
  def change
    add_column :sms_codes, :user_id, :integer
    add_column :sms_codes, :stop, :boolean
    add_index :sms_codes, :user_id
    add_index :sms_codes, :phone
  end
end
