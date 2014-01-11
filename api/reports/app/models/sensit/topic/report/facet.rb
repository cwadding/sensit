module Sensit
  class Topic::Report::Facet < ActiveRecord::Base
  	extend ::FriendlyId
	friendly_id :name, use: [:slugged, :finders]
	  	
  	belongs_to :report
  	serialize :query, Hash

  	validates :name, presence: true, uniqueness: {scope: :report_id}
  	validates :query, presence: true

    def total
      query_results["total"] || 0
    end

    def missing
      query_results["missing"] || 0
    end

    def results
      query_results[query_results["_type"]] || []
    end    


  	def to_query
  		{self.name => self.query}
  	end

private
    def query_results
      @results ||= (report.results["facets"][self.name] || {})
    end    
  end
end
