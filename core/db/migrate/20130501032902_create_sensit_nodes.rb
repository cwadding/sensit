class CreateSensitNodes < ActiveRecord::Migration
  def change
    create_table :sensit_nodes do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
