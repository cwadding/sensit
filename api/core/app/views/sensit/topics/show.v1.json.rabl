object @topic
attribute :id, :name, :description
node :feeds do
	collection @topic.feeds(params)
	extends "sensit/feeds/show"
end
