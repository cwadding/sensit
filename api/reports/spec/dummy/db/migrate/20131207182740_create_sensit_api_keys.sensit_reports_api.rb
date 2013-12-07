# This migration comes from sensit_reports_api (originally 20130425045656)
class CreateSensitApiKeys < ActiveRecord::Migration
  def change
    create_table :sensit_api_keys do |t|
      t.integer :user_id
      t.string :name
      t.string :access_token
      t.datetime :expires_at
      t.integer :access_bitmask

      t.timestamps
    end
  end
end
