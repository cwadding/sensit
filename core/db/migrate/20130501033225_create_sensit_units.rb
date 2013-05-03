class CreateSensitUnits < ActiveRecord::Migration
  def change
    create_table :sensit_units do |t|
      t.string :name
      t.string :kind
      t.string :symbol

      t.timestamps
    end
  end
end
