# This migration comes from sensit_subscriptions (originally 20131201171448)
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
  end
end
