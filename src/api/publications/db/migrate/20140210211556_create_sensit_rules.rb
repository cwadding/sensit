class CreateSensitRules < ActiveRecord::Migration
  def change
    create_table :sensit_rules do |t|
      t.string :name

      t.timestamps
    end
    add_index :sensit_rules, :name, :unique => true
  end
end
