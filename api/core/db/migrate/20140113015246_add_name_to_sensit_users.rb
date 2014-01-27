class AddNameToSensitUsers < ActiveRecord::Migration
	def change
		add_column :sensit_users, :name, :string
	end
end
