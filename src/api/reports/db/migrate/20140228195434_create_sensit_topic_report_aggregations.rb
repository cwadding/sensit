class CreateSensitTopicReportAggregations < ActiveRecord::Migration
  def change
    create_table :sensit_topic_report_aggregations do |t|
      t.integer :report_id
      t.string :name
      t.string :kind
      t.string :ancestry
      t.string :query
      t.timestamps
    end
    add_index :sensit_topic_report_aggregations, :ancestry
    add_index :sensit_topic_report_aggregations, :report_id
    add_foreign_key "sensit_topic_report_aggregations", "sensit_topic_reports", name: "sensit_report_aggregations_report_id_fk", column: "report_id"        
  end
end
