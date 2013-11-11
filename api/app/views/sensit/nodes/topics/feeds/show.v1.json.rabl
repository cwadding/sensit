object @feed
attribute :id, :at
child :fields do
	extends "sensit/nodes/topics/fields/show"
end
child :data_rows => :data do
	node do |u|
		{u.key => u.value}
	end
end
