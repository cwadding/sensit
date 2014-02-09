class CreateSensitTopicPublications < ActiveRecord::Migration
  def change
    create_table :sensit_topic_publications do |t|
      t.string :host
      t.integer :port
      t.string :username
      t.string :password
      t.string :protocol
      t.integer :topic_id
      t.integer :actions_mask

      t.timestamps
    end
  end
end
