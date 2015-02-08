class CreateParkImports < ActiveRecord::Migration
  def change
    create_table :park_imports do |t|
      t.integer :import_id
      t.integer :park_id
      t.string :code
      t.string :province
      t.string :city
      t.string :district
      t.string :name
      t.string :address
      t.string :park_type
      t.string :park_type_code
      t.string :total_count
      t.decimal :gcj_lat, :precision => 10, :scale => 6
      t.decimal :gcj_lng, :precision => 10, :scale => 6
      t.boolean :whole_day
      t.string :day_only
      t.integer :day_time_begin
      t.integer :day_time_end
      t.float :day_first_hour_price
      t.float :day_second_hour_price
      t.float :day_price_per_time
      t.float :night_price_per_night
      t.float :night_price_per_hour
      t.float :whole_day_price_per_time
      t.float :whole_day_price_per_hour
      t.float :night_price_per_hour
      t.integer :night_time_begin
      t.integer :night_time_end
      t.boolean :service_month
      t.integer :month_price
      t.boolean :service_wash
      t.boolean :service_wc
      t.boolean :service_repair
      t.boolean :service_rent
      t.string :service_rent_company
      t.boolean :service_group
      t.boolean :service_times
      t.boolean :is_recommend
      t.boolean :has_service_coupon
      t.boolean :has_service_point
      t.boolean :is_only_service
      t.string :tips
      t.string :lb_staff
      t.string :pic_num
      t.string :originate_from
      t.string :property_owner
      t.timestamps
    end
  end
end
