# This migration comes from sensit (originally 20130501033114)
class CreateSensitTopics < ActiveRecord::Migration
  def change
    create_table :sensit_topics do |t|
      t.string :name
      t.string :description
      t.string :slug
      t.integer :user_id
      t.integer :application_id
      t.integer :ttl
      t.boolean :is_initialized
      t.timestamps
    end
    add_index :sensit_topics, :slug,:unique => true
    add_foreign_key "oauth_access_grants", "oauth_applications", name: "oauth_access_grants_application_id_fk", column: "application_id"
    add_foreign_key "oauth_access_tokens", "oauth_applications", name: "oauth_access_tokens_application_id_fk", column: "application_id"

    add_foreign_key "oauth_access_grants", "sensit_users", name: "oauth_access_grants_resource_owner_id_fk", column: "resource_owner_id"
    add_foreign_key "oauth_access_tokens", "sensit_users", name: "oauth_access_tokens_resource_owner_id_fk", column: "resource_owner_id"
    
    add_foreign_key "sensit_topics", "oauth_applications", name: "sensit_topics_application_id_fk", column: "application_id"
    add_foreign_key "sensit_topics", "sensit_users", name: "sensit_topics_user_id_fk", column: "user_id"
  end
end
