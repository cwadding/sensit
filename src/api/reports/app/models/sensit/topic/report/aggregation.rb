module Sensit
  class Topic::Report::Aggregation < ActiveRecord::Base
 #  	extend ::FriendlyId
	# friendly_id :name, use: [:slugged, :finders]

	has_ancestry

  	belongs_to :report
  	serialize :query, Hash

    AGGREGATION_TYPES = %w[min max sum avg stats extended_stats value_count global filter missing terms range date_range ip_range histogram date_histogram geo_distance geohash_grid]

  	validates :name, presence: true, uniqueness: {scope: :report_id}
    validates :kind, presence: true, inclusion: { in: AGGREGATION_TYPES, message: "%{value} is not a valid aggregation type" }
  	validates :query, presence: true, unless: Proc.new { |a| a.kind == "global"}

  	def aggregations=(params)
  		self.class.new(params.merge!(parent: self))
  	end

    def results
      query_results || []
    end

  	def to_query
  		if has_children?
  			{self.name => {self.kind => self.query, "aggs" => children.inject({}){|h, aggregation| h.merge!(aggregation.to_query)}}}
  		else
			{self.name => {self.kind => self.query}}
  		end
  	end

private
    def query_results
      @results ||= (report.results["aggregations"][self.name] || {})
    end     	
  end
end
