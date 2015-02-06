class CreateAttachmentsParkInstructions < ActiveRecord::Migration
  def change
    create_table :attachments_park_instructions do |t|
      t.string :park_instructions
      t.integer :park_id
      t.string :original_name

      t.timestamps
    end
  end
end
