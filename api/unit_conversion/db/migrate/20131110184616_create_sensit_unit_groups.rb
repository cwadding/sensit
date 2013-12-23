class CreateSensitUnitGroups < ActiveRecord::Migration
  def change
    create_table :sensit_unit_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
