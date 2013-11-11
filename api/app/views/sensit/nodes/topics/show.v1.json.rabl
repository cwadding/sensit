object @topic
attribute :id, :name, :description
child :fields do
	extends "sensit/nodes/topics/fields/show"
end
child :feeds do
	child :data_rows => :data do
		node do |u|
			{u.key => u.value}
		end
	end
end