class CreateSensitMeasurements < ActiveRecord::Migration
  def change
    create_table :sensit_measurements do |t|
      t.integer :sensor_id
      t.integer :unit_id
    end
  end
end
