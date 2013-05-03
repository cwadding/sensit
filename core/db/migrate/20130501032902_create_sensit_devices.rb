class CreateSensitDevices < ActiveRecord::Migration
  def change
    create_table :sensit_devices do |t|
      t.string :title
      t.string :url
      t.string :status
      t.string :description
      t.string :icon
      t.integer :user_id
      t.integer :location_id

      t.timestamps
    end
  end
end
