# This migration comes from sensit (originally 20140113015246)
class AddNameToSensitUsers < ActiveRecord::Migration
	def change
		add_column :sensit_users, :name, :string
	end
end
