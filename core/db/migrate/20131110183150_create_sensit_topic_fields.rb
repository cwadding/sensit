class CreateSensitTopicFields < ActiveRecord::Migration
  def change
    create_table :sensit_topic_fields do |t|
      t.string :name
      t.string :key
      t.integer :unit_id
      t.integer :topic_id
  	  t.string :datatype
      t.timestamps
    end
  end
end
