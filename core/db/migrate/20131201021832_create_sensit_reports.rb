class CreateSensitReports < ActiveRecord::Migration
  def change
    create_table :sensit_reports do |t|
      t.string :name
      t.text :query

      t.timestamps
    end
  end
end
