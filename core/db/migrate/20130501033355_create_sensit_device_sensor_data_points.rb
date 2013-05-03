class CreateSensitDeviceSensorDataPoints < ActiveRecord::Migration
  def change
    create_table :sensit_device_sensor_data_points do |t|
      t.integer :sensor_id
      t.datetime :at
      t.decimal :value

      t.timestamps
    end
  end
end
