# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150228092323) do

  create_table "attachments_park_instructions", force: true do |t|
    t.string   "park_instructions"
    t.integer  "park_id"
    t.string   "original_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments_park_pics", force: true do |t|
    t.string   "park_pic"
    t.integer  "park_id"
    t.string   "original_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imports", force: true do |t|
    t.string   "park_type"
    t.string   "batch_num"
    t.string   "staff_id"
    t.text     "note"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "imported_csv"
    t.string   "code_prefix"
    t.string   "city"
    t.string   "district"
    t.string   "lb_staff"
    t.string   "failed_reason"
  end

  create_table "intros", force: true do |t|
    t.text     "content"
    t.text     "desc"
    t.string   "title"
    t.string   "status"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lb_settings", force: true do |t|
    t.string   "var",        null: false
    t.text     "lb_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lotteries", force: true do |t|
    t.integer  "user_id"
    t.string   "open_num"
    t.string   "serial_num"
    t.integer  "park_status_id"
    t.integer  "park_id"
    t.string   "phone"
    t.datetime "open_at"
    t.text     "notes"
    t.boolean  "win"
    t.integer  "win_amount"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "park_imports", force: true do |t|
    t.integer  "import_id"
    t.integer  "park_id"
    t.string   "code"
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.string   "name"
    t.string   "address"
    t.string   "park_type"
    t.string   "park_type_code"
    t.string   "total_count"
    t.decimal  "gcj_lat",                             precision: 10, scale: 6
    t.decimal  "gcj_lng",                             precision: 10, scale: 6
    t.boolean  "whole_day"
    t.string   "day_only"
    t.integer  "day_time_begin"
    t.integer  "day_time_end"
    t.float    "day_first_hour_price",     limit: 24
    t.float    "day_second_hour_price",    limit: 24
    t.float    "day_price_per_time",       limit: 24
    t.float    "night_price_per_night",    limit: 24
    t.float    "night_price_per_hour",     limit: 24
    t.float    "whole_day_price_per_time", limit: 24
    t.float    "whole_day_price_per_hour", limit: 24
    t.integer  "night_time_begin"
    t.integer  "night_time_end"
    t.boolean  "service_month"
    t.integer  "month_price"
    t.boolean  "service_wash"
    t.boolean  "service_wc"
    t.boolean  "service_repair"
    t.boolean  "service_rent"
    t.string   "service_rent_company"
    t.boolean  "service_group"
    t.boolean  "service_times"
    t.boolean  "is_recommend"
    t.boolean  "has_service_coupon"
    t.boolean  "has_service_point"
    t.boolean  "is_only_service"
    t.string   "tips"
    t.string   "lb_staff"
    t.string   "pic_num"
    t.string   "originate_from"
    t.string   "property_owner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "park_infos", force: true do |t|
    t.integer  "park_id"
    t.text     "day_time"
    t.text     "night_time"
    t.text     "day_price_desc"
    t.text     "all_day_price_desc"
    t.text     "night_price_desc"
    t.text     "times_price_desc"
    t.text     "month_price_desc"
    t.text     "service_wc_desc"
    t.text     "service_wash_desc"
    t.text     "total_count_desc"
    t.text     "day_price_desc_temp"
    t.text     "night_price_desc_temp"
    t.text     "distance_desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "park_owners", force: true do |t|
    t.integer  "park_id"
    t.decimal  "wgs_lat",        precision: 10, scale: 6
    t.decimal  "wgs_lng",        precision: 10, scale: 6
    t.string   "contract"
    t.string   "contract_phone"
    t.string   "ownership"
    t.string   "owner"
    t.text     "desc"
    t.string   "maintainer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "park_statuses", force: true do |t|
    t.string   "status"
    t.integer  "park_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "chosen"
  end

  create_table "parks", force: true do |t|
    t.string   "code"
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.string   "name"
    t.string   "address"
    t.string   "park_type"
    t.string   "park_type_code"
    t.string   "total_count"
    t.decimal  "gcj_lat",                             precision: 10, scale: 6
    t.decimal  "gcj_lng",                             precision: 10, scale: 6
    t.boolean  "whole_day"
    t.string   "day_only"
    t.integer  "day_time_begin"
    t.integer  "day_time_end"
    t.float    "day_first_hour_price",     limit: 24
    t.float    "day_second_hour_price",    limit: 24
    t.float    "day_price_per_time",       limit: 24
    t.float    "night_price_per_night",    limit: 24
    t.float    "night_price_per_hour",     limit: 24
    t.float    "whole_day_price_per_time", limit: 24
    t.float    "whole_day_price_per_hour", limit: 24
    t.integer  "night_time_begin"
    t.integer  "night_time_end"
    t.boolean  "service_month"
    t.integer  "month_price"
    t.boolean  "service_wash"
    t.boolean  "service_wc"
    t.boolean  "service_repair"
    t.boolean  "service_rent"
    t.string   "service_rent_company"
    t.boolean  "service_group"
    t.boolean  "service_times"
    t.boolean  "is_recommend"
    t.boolean  "has_service_coupon"
    t.boolean  "has_service_point"
    t.boolean  "is_only_service"
    t.string   "tips"
    t.string   "lb_staff"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pic_num"
    t.string   "originate_from"
    t.string   "property_owner"
    t.text     "previews"
  end

  create_table "sms_codes", force: true do |t|
    t.string   "phone"
    t.text     "params"
    t.string   "template"
    t.datetime "expire_at"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "stop"
    t.string   "send_reason"
  end

  add_index "sms_codes", ["phone"], name: "index_sms_codes_on_phone", using: :btree
  add_index "sms_codes", ["user_id"], name: "index_sms_codes_on_user_id", using: :btree

  create_table "staffs", force: true do |t|
    t.string   "name"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "email"
    t.string   "phone"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "park_id"
    t.string   "label"
    t.decimal  "lng",        precision: 10, scale: 6
    t.decimal  "lat",        precision: 10, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "token"
    t.string   "encrypted_password"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "status"
    t.string   "openid"
    t.string   "nickname"
    t.boolean  "sex"
    t.string   "language"
    t.string   "province"
    t.string   "city"
    t.datetime "subscribe_time"
    t.string   "unionid"
    t.datetime "last_login_at"
    t.string   "source"
    t.string   "headimg"
  end

  create_table "users_parks", force: true do |t|
    t.integer  "user_id"
    t.integer  "park_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wechat_user_activities", force: true do |t|
    t.integer  "wechat_user_id"
    t.string   "activity"
    t.string   "sub_activity"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wechat_users", force: true do |t|
    t.integer  "user_id"
    t.string   "status"
    t.string   "openid"
    t.string   "nickname"
    t.integer  "sex"
    t.string   "language"
    t.string   "province"
    t.string   "city"
    t.string   "country"
    t.string   "headimg"
    t.text     "remark"
    t.datetime "subscribe_time"
    t.string   "unionid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
