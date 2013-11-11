class CreateSensitUnits < ActiveRecord::Migration
  def change
    create_table :sensit_units do |t|
      t.string :name
      t.string :abbr
      t.integer :datatype_id
      t.integer :group_id

      t.timestamps
    end
  end
end
