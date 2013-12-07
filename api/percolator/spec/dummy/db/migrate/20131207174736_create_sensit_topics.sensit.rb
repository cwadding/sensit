# This migration comes from sensit (originally 20130501033114)
class CreateSensitTopics < ActiveRecord::Migration
  def change
    create_table :sensit_topics do |t|
      t.integer :api_key_id
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
