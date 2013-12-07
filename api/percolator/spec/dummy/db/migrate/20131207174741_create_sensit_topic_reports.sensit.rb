# This migration comes from sensit (originally 20131201021832)
class CreateSensitTopicReports < ActiveRecord::Migration
  def change
    create_table :sensit_topic_reports do |t|
      t.string :name
      t.text :query
      t.integer :topic_id
      t.timestamps
    end
  end
end
