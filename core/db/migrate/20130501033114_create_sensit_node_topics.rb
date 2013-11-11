class CreateSensitNodeTopics < ActiveRecord::Migration
  def change
    create_table :sensit_node_topics do |t|
      t.integer :node_id
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
