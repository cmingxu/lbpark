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

ActiveRecord::Schema.define(version: 20141120143753) do

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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "park_owners", force: true do |t|
    t.integer  "park_id"
    t.decimal  "wgs_lat",        precision: 10, scale: 0
    t.decimal  "wgs_lng",        precision: 10, scale: 0
    t.string   "contract"
    t.string   "contract_phone"
    t.string   "ownership"
    t.string   "owner"
    t.text     "desc"
    t.string   "maitainer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parks", force: true do |t|
    t.string   "code"
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.string   "name"
    t.string   "address"
    t.string   "park_type"
    t.string   "total_count"
    t.decimal  "gcj_lat",               precision: 10, scale: 0
    t.decimal  "gcj_lng",               precision: 10, scale: 0
    t.boolean  "whole_day"
    t.string   "day_only"
    t.integer  "day_time_begin"
    t.integer  "day_time_end"
    t.integer  "day_price"
    t.decimal  "day_first_hour_price",  precision: 10, scale: 0
    t.decimal  "day_second_hour_price", precision: 10, scale: 0
    t.integer  "night_time_begin"
    t.integer  "night_time_end"
    t.decimal  "night_price",           precision: 10, scale: 0
    t.integer  "night_price_hour"
    t.integer  "times_price"
    t.boolean  "service_month"
    t.integer  "month_price"
    t.boolean  "service_wash"
    t.boolean  "service_wc"
    t.boolean  "service_repair"
    t.boolean  "service_rent"
    t.boolean  "service_rent_company"
    t.boolean  "service_group"
    t.boolean  "service_times"
    t.boolean  "is_recommend"
    t.boolean  "has_service_coupon"
    t.boolean  "has_service_pointeger"
    t.boolean  "is_only_service"
    t.decimal  "times_price_all_day",   precision: 10, scale: 0
    t.string   "tips"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
