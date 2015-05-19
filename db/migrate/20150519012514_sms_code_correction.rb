class SmsCodeCorrection < ActiveRecord::Migration
  def change
    add_column :sms_codes, :owner_type, :string
    add_column :sms_codes, :owner_id, :integer
  end
end
