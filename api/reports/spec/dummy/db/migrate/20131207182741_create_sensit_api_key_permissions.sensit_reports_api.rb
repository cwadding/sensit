# This migration comes from sensit_reports_api (originally 20130425045919)
class CreateSensitApiKeyPermissions < ActiveRecord::Migration
  def change
    create_table :sensit_api_key_permissions do |t|
      t.integer :api_key_id
      t.integer :access_methods_bitmask
      t.string :source_ip
      t.string :referer
      t.integer :minimum_interval
      t.string :name

      t.timestamps
    end
  end
end
