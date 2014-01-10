class CreateSensitTopicReportFacets < ActiveRecord::Migration
  def change
    create_table :sensit_topic_report_facets do |t|
      t.string :name
      t.text :body
      t.integer :report_id
      t.foreign_key :reports, dependent: :delete
      t.timestamps
    end
  end
end
