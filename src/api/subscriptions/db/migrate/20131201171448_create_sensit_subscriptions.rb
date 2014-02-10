class CreateSensitSubscriptions < ActiveRecord::Migration
  def change
    create_table :sensit_subscriptions do |t|
      t.string :name
      t.string :protocol
      t.string :host
      t.integer :port
      t.string :username
      t.string :password_digest
      t.integer :user_id
      t.integer :application_id
      t.string :slug
      t.timestamps
    end
    add_index :sensit_subscriptions, :slug,:unique => true
    add_foreign_key "sensit_subscriptions", "oauth_applications", name: "sensit_subscriptions_application_id_fk", column: "application_id"
    add_foreign_key "sensit_subscriptions", "sensit_users", name: "sensit_subscriptions_user_id_fk", column: "user_id"    
  end
end
