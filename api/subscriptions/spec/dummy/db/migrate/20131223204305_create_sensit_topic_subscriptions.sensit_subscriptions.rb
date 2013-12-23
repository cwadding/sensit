# This migration comes from sensit_subscriptions (originally 20131201171448)
class CreateSensitTopicSubscriptions < ActiveRecord::Migration
  def change
    create_table :sensit_topic_subscriptions do |t|
      t.string :name
      t.string :host
      t.string :auth_token
      t.string :protocol
      t.integer :topic_id
      t.string :slug
      t.timestamps
    end
  end
end
