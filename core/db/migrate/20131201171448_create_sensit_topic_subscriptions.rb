class CreateSensitTopicSubscriptions < ActiveRecord::Migration
  def change
    create_table :sensit_topic_subscriptions do |t|
      t.string :name
      t.string :host
      t.string :auth_token
      t.string :protocol
      t.integer :topic_id
      t.timestamps
    end
  end
end
