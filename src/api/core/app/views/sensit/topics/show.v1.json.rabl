object @topic
cache @topic
attribute :id, :name, :description

child @topic.feeds(params) => :feeds do
	attributes :id

	node :at do |u|
		u.at.utc.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")
	end

	node :tz do |u|
		u.at.time_zone.name
	end
	node :data do |u|
		u.data
	end
end unless @topic.blank?

child :fields => "fields" do
	extends "sensit/fields/show"
end unless @topic.blank?