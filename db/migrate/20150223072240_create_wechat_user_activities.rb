class CreateWechatUserActivities < ActiveRecord::Migration
  def change
    create_table :wechat_user_activities do |t|
      t.integer :wechat_user_id
      t.string :openid
      t.string :activity
      t.string :sub_activity
      t.text :params

      t.timestamps
    end
  end
end
