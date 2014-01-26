object @report
attribute :name, :total, :query
child :facets => "facets" do
	attribute :name, :query, :total, :missing, :results
end