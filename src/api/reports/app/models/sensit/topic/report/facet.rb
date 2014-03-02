module Sensit
  class Topic::Report::Facet < ActiveRecord::Base
  	extend ::FriendlyId
	friendly_id :name, use: [:slugged, :finders]
	  	
  	belongs_to :report
  	serialize :query, Hash

    FACET_TYPES = %w[terms range histogram date_histogram filter query statistical terms_stats geo_distance]

  	validates :name, presence: true, uniqueness: {scope: :report_id}
    validates :kind, presence: true, inclusion: { in: FACET_TYPES, message: "%{value} is not a valid facet type" }
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
  		{self.name => {self.kind => self.query}}
  	end

private
    def query_results
      @results ||= (report.results["facets"][self.name] || {})
    end    
  end
end
