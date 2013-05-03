class CreateSensitDeviceSensors < ActiveRecord::Migration
  def change
    create_table :sensit_device_sensors do |t|
      t.integer :unit_id
      t.integer :min_value
      t.integer :max_value
      t.integer :start_value
      t.integer :device_id

      t.timestamps
    end
  end
end
