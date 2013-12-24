class AddTtlToSensitTopic < ActiveRecord::Migration
  def change
    add_column :sensit_topics, :ttl, :integer
  end
end
