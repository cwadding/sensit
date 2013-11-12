object @node
attribute :id, :name, :description
child :topics do
	extends "sensit/topics/show"
end