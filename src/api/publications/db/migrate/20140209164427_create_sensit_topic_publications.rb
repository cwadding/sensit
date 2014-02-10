class CreateSensitTopicPublications < ActiveRecord::Migration
  def change
    create_table :sensit_topic_publications do |t|
      t.string :host
      t.integer :port
      t.string :username
      t.string :password_digest
      t.string :protocol
      t.integer :topic_id
      t.integer :actions_mask

      t.timestamps
    end
    add_foreign_key "sensit_publications", "sensit_topics", name: "sensit_publications_topic_id_fk", column: "topic_id"    

  end
end
