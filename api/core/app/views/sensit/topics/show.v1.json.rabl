object @topic
attribute :id, :name, :description
child :feeds do
	node :at do |u|
		u.at.utc.iso8601
	end
	node :data do |u|
		u.values
	end
end
