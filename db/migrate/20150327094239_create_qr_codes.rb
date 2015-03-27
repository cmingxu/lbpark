class CreateQrCodes < ActiveRecord::Migration
  def change
    create_table :qr_codes do |t|
      t.string :appid
      t.string :which_wechat_account
      t.string :status
      t.string :qr_code
      t.string :ticket
      t.string :scene_str
      t.string :mark

      t.timestamps
    end
  end
end
