object false

child @feeds => :feeds do
	collection @feeds
	
	attributes :id

	node :at do |u|
		u.at.utc.to_f
	end

	node :tz do |u|
		u.at.time_zone.name
	end
	node :data do |u|
		u.values
	end
end

child @fields => :fields do
  collection @fields
  extends "sensit/fields/show"
end