object @report
attribute :name, :total, :query
child :facets do
	attribute :name, :query, :total, :missing, :results
end