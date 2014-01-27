object @topic
attribute :id, :name, :description
child :fields => "fields" do
	extends "sensit/fields/show"
end
child :feeds do
	node :at do |u|
		u.at.utc.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")
	end
	node :data do |u|
		u.values
	end
end
