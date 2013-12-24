object @topic
attribute :id, :name, :description
child :feeds do
	node :at do |u|
		u.at.utc.to_f
	end
	node :data do |u|
		u.values
	end
end
