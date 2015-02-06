class CreateAttachmentsParkPics < ActiveRecord::Migration
  def change
    create_table :attachments_park_pics do |t|
      t.string :park_pic
      t.integer :park_id
      t.string :original_name

      t.timestamps
    end
  end
end
