# This migration comes from sensit (originally 20130501033114)
class CreateSensitTopics < ActiveRecord::Migration
  def change
    create_table :sensit_topics do |t|
      t.string :name
      t.string :description
      t.string :slug
      t.integer :user_id
      t.integer :application_id
      t.integer :ttl
      t.boolean :is_initialized
      t.timestamps
    end
  end
end
