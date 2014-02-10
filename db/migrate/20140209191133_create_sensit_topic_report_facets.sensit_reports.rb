# This migration comes from sensit_reports (originally 20140103161721)
class CreateSensitTopicReportFacets < ActiveRecord::Migration
  def change
    create_table :sensit_topic_report_facets do |t|
      t.string :name
      t.string :kind
      t.string :slug      
      t.text :query
      t.integer :report_id
      # t.foreign_key :reports
      t.timestamps
    end
    add_index :sensit_topic_report_facets, :slug,:unique => true
    add_foreign_key "sensit_topic_report_facets", "sensit_topic_reports", name: "sensit_report_facets_report_id_fk", column: "report_id"
  end
end
