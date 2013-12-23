object @feed
attributes :id

node :at do |u|
	u.at.utc.to_f
end

node :tz do |u|
	u.at.time_zone.name
end

child :fields do
	extends "sensit/fields/show"
end
node :data do |u|
	u.values
end
