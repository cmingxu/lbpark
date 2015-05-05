class CreateParkNoticeItems < ActiveRecord::Migration
  def change
    create_table :park_notice_items do |t|
      t.text :content
      t.integer :position
      t.integer :coupon_tpl_id
      t.integer :park_id
      t.timestamps
    end
  end
end
