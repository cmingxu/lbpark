class CreateSmsCodes < ActiveRecord::Migration
  def change
    create_table :sms_codes do |t|
      t.string :phone
      t.text :params
      t.string :template
      t.string :send_reason
      t.datetime :expire_at
      t.string :status

      t.timestamps
    end
  end
end
