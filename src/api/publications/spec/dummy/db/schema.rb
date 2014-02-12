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

ActiveRecord::Schema.define(version: 20140211141805) do

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true

  create_table "oauth_applications", force: true do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true

  create_table "sensit_percolations", force: true do |t|
    t.integer  "publication_id"
    t.integer  "rule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_rules", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sensit_rules", ["name"], name: "index_sensit_rules_on_name", unique: true

  create_table "sensit_topic_fields", force: true do |t|
    t.string   "name"
    t.string   "key"
    t.integer  "unit_id"
    t.integer  "topic_id"
    t.string   "datatype"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sensit_topic_fields", ["key"], name: "index_sensit_topic_fields_on_key", unique: true
  add_index "sensit_topic_fields", ["slug"], name: "index_sensit_topic_fields_on_slug", unique: true

  create_table "sensit_topic_publications", force: true do |t|
    t.string   "host"
    t.integer  "port"
    t.string   "username"
    t.string   "password_digest"
    t.string   "protocol"
    t.integer  "topic_id"
    t.integer  "actions_mask"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensit_topics", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "slug"
    t.integer  "user_id"
    t.integer  "application_id"
    t.integer  "ttl"
    t.boolean  "is_initialized"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sensit_topics", ["slug"], name: "index_sensit_topics_on_slug", unique: true

  create_table "sensit_users", force: true do |t|
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
    t.string   "name"
  end

  add_index "sensit_users", ["email"], name: "index_sensit_users_on_email", unique: true
  add_index "sensit_users", ["reset_password_token"], name: "index_sensit_users_on_reset_password_token", unique: true

end
