collection @topics => :topics

attribute :name, :description

node :id do |u|
	u.slug
end