object @feed
attributes :id

node :at do |u|
	u.at.utc.iso8601
end

node :tz do |u|
	u.at.time_zone.name
end
node :data do |u|
	u.values
end
