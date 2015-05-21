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

ActiveRecord::Schema.define(version: 20150521011626) do

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

  create_table "client_members", force: true do |t|
    t.integer  "client_id"
    t.integer  "member_id"
    t.integer  "client_user_id"
    t.string   "source"
    t.string   "name"
    t.string   "phone"
    t.string   "paizhao"
    t.string   "driver_license_pic"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_memberships", force: true do |t|
    t.integer  "client_member_id"
    t.integer  "order_id"
    t.datetime "begin_at"
    t.datetime "end_at"
    t.integer  "month_count"
    t.integer  "total_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "park_space_id"
  end

  create_table "client_users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "last_login_at"
    t.string   "last_login_ip"
    t.integer  "park_id"
    t.text     "plugins"
    t.integer  "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "login"
    t.boolean  "phone_verified"
    t.string   "sms_verification_code"
    t.boolean  "password_changed"
    t.integer  "client_id"
  end

  create_table "clients", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_scans", force: true do |t|
    t.integer  "coupon_id"
    t.integer  "coupon_tpl_id"
    t.integer  "scan_by_id"
    t.decimal  "gcj_lat",       precision: 10, scale: 6
    t.decimal  "gcj_lng",       precision: 10, scale: 6
    t.integer  "park_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_tpls", force: true do |t|
    t.integer  "park_id"
    t.integer  "priority"
    t.integer  "staff_id"
    t.string   "type"
    t.string   "identifier"
    t.string   "name_cn"
    t.date     "fit_for_date"
    t.datetime "end_at"
    t.decimal  "gcj_lat",                   precision: 10, scale: 6
    t.decimal  "gcj_lng",                   precision: 10, scale: 6
    t.integer  "quantity"
    t.integer  "price"
    t.integer  "copy_from"
    t.string   "status"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "banner"
    t.string   "notice"
    t.integer  "coupon_value"
    t.integer  "valid_hour_begin"
    t.integer  "valid_hour_end"
    t.integer  "lower_limit_for_deduct"
    t.string   "valid_dates"
    t.boolean  "park_space_choose_enabled"
  end

  create_table "coupons", force: true do |t|
    t.integer  "park_id"
    t.integer  "coupon_tpl_id"
    t.string   "identifier"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "end_at"
    t.integer  "price"
    t.string   "issued_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "claimed_at"
    t.date     "fit_for_date"
    t.string   "coupon_tpl_type"
    t.datetime "expire_at"
    t.string   "qr_code"
    t.date     "issued_begin_date"
    t.datetime "used_at"
    t.string   "issued_paizhao"
    t.integer  "quantity"
    t.string   "issued_park_space"
  end

  create_table "feedbacks", force: true do |t|
    t.string   "contact"
    t.text     "content"
    t.string   "status"
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
    t.string   "lucky_num"
    t.integer  "red_lucky_num_hits"
    t.boolean  "blue_ball_hit"
    t.integer  "money_get"
    t.string   "why"
  end

  create_table "messages", force: true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.string   "order_num"
    t.integer  "park_id"
    t.integer  "user_id"
    t.string   "status"
    t.integer  "price"
    t.integer  "coupon_id"
    t.datetime "paid_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "body"
    t.string   "spbill_create_ip"
    t.string   "notify_url"
    t.string   "bank_type"
    t.string   "transaction_id"
    t.string   "ip"
    t.string   "prepay_id"
    t.integer  "quantity"
  end

  create_table "pages", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "content_type"
    t.integer  "edit_by"
    t.string   "permalink"
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
    t.string   "same_as"
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

  create_table "park_map_eles", force: true do |t|
    t.integer  "park_map_id"
    t.integer  "park_id"
    t.string   "park_map_ele_type"
    t.text     "ele_desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
  end

  create_table "park_maps", force: true do |t|
    t.integer  "park_id"
    t.string   "version"
    t.datetime "last_edit_at"
    t.integer  "last_edit_by"
    t.string   "layer"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "park_notice_items", force: true do |t|
    t.text     "content"
    t.integer  "position"
    t.integer  "coupon_tpl_id"
    t.integer  "park_id"
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

  create_table "park_spaces", force: true do |t|
    t.string   "name"
    t.string   "uuid"
    t.integer  "park_map_id"
    t.integer  "park_id"
    t.integer  "park_map_ele_id"
    t.string   "usage_status"
    t.string   "vacancy_status"
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
    t.string   "pinyin"
    t.string   "same_as"
    t.integer  "client_id"
  end

  create_table "plugin_tpls", force: true do |t|
    t.string   "identifier"
    t.string   "name"
    t.string   "icon"
    t.string   "big_icon"
    t.decimal  "base_price",     precision: 10, scale: 0
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default_to_all"
    t.string   "entry_url"
    t.string   "fa_icon"
  end

  create_table "plugins", force: true do |t|
    t.integer  "client_id"
    t.integer  "plugin_tpl_id"
    t.datetime "begin_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled"
  end

  create_table "qr_codes", force: true do |t|
    t.string   "appid"
    t.string   "which_wechat_account"
    t.string   "status"
    t.string   "qr_code"
    t.string   "ticket"
    t.string   "scene_str"
    t.string   "mark"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "owner_type"
    t.integer  "owner_id"
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
    t.string   "nickname",             limit: 250
    t.boolean  "sex"
    t.string   "language"
    t.string   "province"
    t.string   "city"
    t.datetime "subscribe_time"
    t.string   "unionid"
    t.datetime "last_login_at"
    t.string   "source"
    t.string   "headimg"
    t.boolean  "scan_coupon"
    t.boolean  "can_check_high_score",             default: false
    t.string   "ticket"
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
    t.string   "openid"
  end

  create_table "wechat_users", force: true do |t|
    t.integer  "user_id"
    t.string   "status"
    t.string   "openid"
    t.string   "nickname",       limit: 250
    t.integer  "sex"
    t.string   "language"
    t.string   "province"
    t.string   "city"
    t.string   "country"
    t.string   "headimg"
    t.text     "remark",         limit: 16777215
    t.datetime "subscribe_time"
    t.string   "unionid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ticket"
  end

end
