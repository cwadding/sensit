class CreateSensitDatatypes < ActiveRecord::Migration
  def change
    create_table :sensit_datatypes do |t|
      t.string :name

      t.timestamps
    end
  end
end
