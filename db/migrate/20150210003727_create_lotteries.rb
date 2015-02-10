class CreateLotteries < ActiveRecord::Migration
  def change
    create_table :lotteries do |t|
      t.integer :user_id
      t.string :open_num
      t.string :serial_num
      t.integer :park_status_id
      t.integer :park_id
      t.string :phone
      t.datetime :open_at
      t.text :notes
      t.boolean :win
      t.integer :win_amount
      t.string :status

      t.timestamps
    end
  end
end
