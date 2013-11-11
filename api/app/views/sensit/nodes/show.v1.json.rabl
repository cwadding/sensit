object @node
attribute :id, :name, :description
child :topics do
	extends "sensit/nodes/topics/show"
end