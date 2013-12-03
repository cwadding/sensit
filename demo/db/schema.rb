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

ActiveRecord::Schema.define(version: 20131203005234) do

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

  create_table "sensit_datatypes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_topic_fields", force: true do |t|
    t.string   "name"
    t.string   "key"
    t.integer  "unit_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_topic_reports", force: true do |t|
    t.string   "name"
    t.text     "query"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_topic_subscriptions", force: true do |t|
    t.string   "name"
    t.string   "host"
    t.string   "auth_token"
    t.string   "protocol"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_topics", force: true do |t|
    t.integer  "api_key_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_unit_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_units", force: true do |t|
    t.string   "name"
    t.string   "abbr"
    t.integer  "datatype_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
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
