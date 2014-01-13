# This migration comes from sensit (originally 20140113015246)
class CreateSensitUsers < ActiveRecord::Migration
  def change
    create_table :sensit_users do |t|
      t.string :name 
      t.timestamps
    end
  end
end
