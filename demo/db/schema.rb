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

ActiveRecord::Schema.define(version: 20130503025336) do

  create_table "sensit_api_key_permission_restrictions", force: true do |t|
    t.integer  "api_key_permission_id"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_api_key_permissions", force: true do |t|
    t.integer  "api_key_id"
    t.integer  "access_methods_bitmask"
    t.string   "source_ip"
    t.string   "referer"
    t.integer  "minimum_interval"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_api_keys", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "access_token"
    t.datetime "expires_at"
    t.integer  "access_bitmask"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_device_sensor_data_points", force: true do |t|
    t.integer  "sensor_id"
    t.datetime "at"
    t.decimal  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_device_sensors", force: true do |t|
    t.integer  "unit_id"
    t.integer  "min_value"
    t.integer  "max_value"
    t.integer  "start_value"
    t.integer  "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_devices", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "status"
    t.string   "description"
    t.string   "icon"
    t.integer  "user_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_measurements", force: true do |t|
    t.integer "sensor_id"
    t.integer "unit_id"
  end

  create_table "sensit_units", force: true do |t|
    t.string   "name"
    t.string   "kind"
    t.string   "symbol"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
