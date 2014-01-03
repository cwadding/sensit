class AddApiKeyIdToSensitTopics < ActiveRecord::Migration
  def change
    add_column :sensit_topics, :api_key_id, :integer
  end
end
