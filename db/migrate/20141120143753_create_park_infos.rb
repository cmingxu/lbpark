class CreateParkInfos < ActiveRecord::Migration
  def change
    create_table :park_infos do |t|
      t.integer :park_id
      t.text :day_time
      t.text :night_time
      t.text :day_price_desc
      t.text :all_day_price_desc
      t.text :night_price_desc
      t.text :times_price_desc
      t.text :month_price_desc
      t.text :service_wc_desc
      t.text :service_wash_desc
      t.text :total_count_desc
      t.text :day_price_desc_temp
      t.text :night_price_desc_temp
      t.text :distance_desc

      t.timestamps
    end
  end
end
