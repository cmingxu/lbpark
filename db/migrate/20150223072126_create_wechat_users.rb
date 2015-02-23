class CreateWechatUsers < ActiveRecord::Migration
  def change
    create_table :wechat_users do |t|
      t.integer :user_id
      t.string :status
      t.string :openid
      t.string :nickname
      t.integer :sex
      t.string :language
      t.string :province
      t.string :city
      t.string :country
      t.string :headimg
      t.text :remark
      t.datetime :subscribe_time
      t.string :unionid

      t.timestamps
    end
  end
end
