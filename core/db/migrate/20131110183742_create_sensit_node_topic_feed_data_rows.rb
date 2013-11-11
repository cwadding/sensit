class CreateSensitNodeTopicFeedDataRows < ActiveRecord::Migration
  def change
    create_table :sensit_node_topic_feed_data_rows do |t|
      t.integer :feed_id
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
