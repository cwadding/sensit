# This migration comes from sensit (originally 20131110183150)
class CreateSensitTopicFields < ActiveRecord::Migration
  def change
    create_table :sensit_topic_fields do |t|
      t.string :name
      t.string :key
      t.integer :unit_id
      t.integer :topic_id
  	  t.string :datatype
      t.string :slug
      t.timestamps
    end
    add_index :sensit_topic_fields, :key,:unique => true
    add_index :sensit_topic_fields, :slug,:unique => true
    add_foreign_key "sensit_topic_fields", "sensit_topics", name: "sensit_topic_fields_topic_id_fk", column: "topic_id"    
  end
end
