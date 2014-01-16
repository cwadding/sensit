class CreateSensitUsers < ActiveRecord::Migration
  def change
    create_table :sensit_users do |t|
      t.string :name 
      t.string :password_digest
      t.timestamps
    end
  end
end
