class CreateSensitNodeTopicFeeds < ActiveRecord::Migration
  def change
    create_table :sensit_node_topic_feeds do |t|
      t.integer :topic_id
      t.datetime :at
      t.timestamps
    end
  end
end
