# This migration comes from sensit_schema_api (originally 20130425050226)
class CreateSensitApiKeyPermissionRestrictions < ActiveRecord::Migration
  def change
    create_table :sensit_api_key_permission_restrictions do |t|
      t.integer :api_key_permission_id
      t.string :resource_type
      t.integer :resource_id

      t.timestamps
    end
  end
end
