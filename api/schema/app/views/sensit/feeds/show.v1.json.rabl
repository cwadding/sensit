object @feed
attributes :id, :tz

node :at do |u|
	u.at.utc.to_f
end

child :fields do
	extends "sensit/fields/show"
end
node :data do |u|
	u.values
end
