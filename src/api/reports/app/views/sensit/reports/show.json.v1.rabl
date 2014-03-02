object @report
cache @report
attribute :name, :total, :query
child :aggregations => "aggregations" do
	attribute :name, :query, :results
	node "type" do |u|
		u.kind
	end
end