class CreateSensitTopics < ActiveRecord::Migration
  def change
    create_table :sensit_topics do |t|
      t.string :name
      t.string :description
      t.string :slug
      t.timestamps
    end
  end
end