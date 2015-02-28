class AddWechatColumnForUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :string
    add_column :users, :openid, :string
    add_column :users, :nickname, :string
    add_column :users, :sex, :boolean
    add_column :users, :language, :string
    add_column :users, :province, :string
    add_column :users, :city, :string
    add_column :users, :subscribe_time, :datetime
    add_column :users, :unionid, :string
    add_column :users, :last_login_at, :datetime
    add_column :users, :source, :string
    add_column :users, :headimg, :string
  end
end
