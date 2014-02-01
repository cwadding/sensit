object @topic
attribute :id, :name, :description

child @topic.feeds(params) => :feeds do
	extends "sensit/feeds/show"
end unless @topic.blank?
