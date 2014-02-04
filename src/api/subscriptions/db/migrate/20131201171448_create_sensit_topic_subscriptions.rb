class CreateSensitTopicSubscriptions < ActiveRecord::Migration
  def change
    create_table :sensit_topic_subscriptions do |t|
      t.string :name
      t.string :protocol
      t.string :host
      t.integer :port
      t.string :username
      t.string :password_digest
      t.integer :topic_id
      t.string :slug
      t.timestamps
    end
  end
end
