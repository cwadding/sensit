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

ActiveRecord::Schema.define(version: 20140302202908) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

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

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

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

  add_index "sensit_rules", ["name"], name: "index_sensit_rules_on_name", unique: true, using: :btree

  create_table "sensit_subscriptions", force: true do |t|
    t.string   "name"
    t.string   "protocol"
    t.string   "host"
    t.integer  "port"
    t.string   "username"
    t.string   "password_digest"
    t.integer  "user_id"
    t.integer  "application_id"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sensit_subscriptions", ["slug"], name: "index_sensit_subscriptions_on_slug", unique: true, using: :btree

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

  add_index "sensit_topic_fields", ["key"], name: "index_sensit_topic_fields_on_key", unique: true, using: :btree
  add_index "sensit_topic_fields", ["slug"], name: "index_sensit_topic_fields_on_slug", unique: true, using: :btree

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

  create_table "sensit_topic_report_aggregations", force: true do |t|
    t.integer  "report_id"
    t.string   "name"
    t.string   "kind"
    t.string   "ancestry"
    t.string   "query"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sensit_topic_report_aggregations", ["ancestry"], name: "index_sensit_topic_report_aggregations_on_ancestry", using: :btree
  add_index "sensit_topic_report_aggregations", ["report_id"], name: "index_sensit_topic_report_aggregations_on_report_id", using: :btree

  create_table "sensit_topic_report_facets", force: true do |t|
    t.string   "name"
    t.string   "kind"
    t.string   "slug"
    t.text     "query"
    t.integer  "report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sensit_topic_report_facets", ["slug"], name: "index_sensit_topic_report_facets_on_slug", unique: true, using: :btree

  create_table "sensit_topic_reports", force: true do |t|
    t.string   "name"
    t.text     "query"
    t.integer  "topic_id"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sensit_topic_reports", ["slug"], name: "index_sensit_topic_reports_on_slug", unique: true, using: :btree

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

  add_index "sensit_topics", ["slug"], name: "index_sensit_topics_on_slug", unique: true, using: :btree

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

  add_index "sensit_users", ["email"], name: "index_sensit_users_on_email", unique: true, using: :btree
  add_index "sensit_users", ["reset_password_token"], name: "index_sensit_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "oauth_access_grants", "oauth_applications", name: "oauth_access_grants_application_id_fk", column: "application_id"
  add_foreign_key "oauth_access_grants", "sensit_users", name: "oauth_access_grants_resource_owner_id_fk", column: "resource_owner_id"

  add_foreign_key "oauth_access_tokens", "oauth_applications", name: "oauth_access_tokens_application_id_fk", column: "application_id"
  add_foreign_key "oauth_access_tokens", "sensit_users", name: "oauth_access_tokens_resource_owner_id_fk", column: "resource_owner_id"

  add_foreign_key "sensit_percolations", "sensit_rules", name: "sensit_percolations_rule_id_fk", column: "rule_id"
  add_foreign_key "sensit_percolations", "sensit_topic_publications", name: "sensit_topic_publications_publication_id_fk", column: "publication_id"

  add_foreign_key "sensit_subscriptions", "oauth_applications", name: "sensit_subscriptions_application_id_fk", column: "application_id"
  add_foreign_key "sensit_subscriptions", "sensit_users", name: "sensit_subscriptions_user_id_fk", column: "user_id"

  add_foreign_key "sensit_topic_fields", "sensit_topics", name: "sensit_topic_fields_topic_id_fk", column: "topic_id"

  add_foreign_key "sensit_topic_publications", "sensit_topics", name: "sensit_topic_publications_topic_id_fk", column: "topic_id"

  add_foreign_key "sensit_topic_report_aggregations", "sensit_topic_reports", name: "sensit_report_aggregations_report_id_fk", column: "report_id"

  add_foreign_key "sensit_topic_report_facets", "sensit_topic_reports", name: "sensit_report_facets_report_id_fk", column: "report_id"

  add_foreign_key "sensit_topic_reports", "sensit_topics", name: "sensit_topic_reports_topic_id_fk", column: "topic_id"

  add_foreign_key "sensit_topics", "oauth_applications", name: "sensit_topics_application_id_fk", column: "application_id"
  add_foreign_key "sensit_topics", "sensit_users", name: "sensit_topics_user_id_fk", column: "user_id"

end
