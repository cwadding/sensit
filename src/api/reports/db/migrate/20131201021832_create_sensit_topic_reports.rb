class CreateSensitTopicReports < ActiveRecord::Migration
  def change
    create_table :sensit_topic_reports do |t|
      t.string :name
      t.text :query
      t.integer :topic_id
      t.string :slug
      t.timestamps
      t.foreign_key :topics, dependent: :delete
    end
  end
end