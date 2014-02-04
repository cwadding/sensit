# This migration comes from sensit_reports (originally 20140103161721)
class CreateSensitTopicReportFacets < ActiveRecord::Migration
  def change
    create_table :sensit_topic_report_facets do |t|
      t.string :name
      t.string :type
      t.string :slug      
      t.text :query
      t.integer :report_id
      # t.foreign_key :reports
      t.timestamps
    end
  end
end
