class CreateSensitTopicReports < ActiveRecord::Migration
  def change
    create_table :sensit_topic_reports do |t|
      t.string :name
      t.text :query
      t.integer :topic_id
      t.string :slug
      t.timestamps
      # t.foreign_key :topics, dependent: :delete
    end
    add_index :sensit_topic_reports, :slug,:unique => true
    add_foreign_key "sensit_topic_reports", "sensit_topics", name: "sensit_topic_reports_topic_id_fk", column: "topic_id"    
  end
end