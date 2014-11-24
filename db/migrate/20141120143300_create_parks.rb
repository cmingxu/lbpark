class CreateParks < ActiveRecord::Migration
  def change
    create_table :parks do |t|
      t.string :code
      t.string :province
      t.string :city
      t.string :district
      t.string :name
      t.string :address
      t.string :park_type
      t.string :total_count
      t.decimal :gcj_lat
      t.decimal :gcj_lng
      t.boolean :whole_day
      t.string :day_only
      t.integer :day_time_begin
      t.integer :day_time_end
      t.integer :day_price
      t.decimal :day_first_hour_price
      t.decimal :day_second_hour_price
      t.integer :night_time_begin
      t.integer :night_time_end
      t.decimal :night_price
      t.integer :night_price_hour
      t.integer :times_price
      t.boolean :service_month
      t.integer :month_price
      t.boolean :service_wash
      t.boolean :service_wc
      t.boolean :service_repair
      t.boolean :service_rent
      t.boolean :service_rent_company
      t.boolean :service_group
      t.boolean :service_times
      t.boolean :is_recommend
      t.boolean :has_service_coupon
      t.boolean :has_service_point
      t.boolean :is_only_service
      t.decimal :times_price_all_day
      t.string :tips

      t.timestamps
    end
  end
end
