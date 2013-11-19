object @topic
attribute :id, :name, :description
child :fields do
	extends "sensit/fields/show"
end
child :feeds do
	node :data do |u|
		u.values
	end
end
