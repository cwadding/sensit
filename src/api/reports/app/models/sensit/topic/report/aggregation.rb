module Sensit
  class Topic::Report::Aggregation < ActiveRecord::Base
 #  	extend ::FriendlyId
	# friendly_id :name, use: [:slugged, :finders]
  after_save :save_all_aggregations
	has_ancestry

  	belongs_to :report
  	serialize :query, Hash

    attr_reader :aggregations

    AGGREGATION_TYPES = %w[min max sum avg stats extended_stats value_count global filter missing terms range date_range ip_range histogram date_histogram geo_distance geohash_grid]

  	validates :name, presence: true, uniqueness: {scope: :report_id}
    validates :kind, presence: true, inclusion: { in: AGGREGATION_TYPES, message: "%{value} is not a valid aggregation type" }
  	validates :query, presence: true, unless: Proc.new { |a| a.kind == "global"}

  	def aggregations=(params_array)
      @aggregations = params_array.map do |params|
        aggs = params.delete(:aggregations)
  		  child = self.class.new(params)
        child.aggregations = aggs unless aggs.nil?
        child
      end
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

    def save_all_aggregations
      aggregations.each do |agg|
        agg.parent = self
        agg.save
      end unless aggregations.nil?
    end

  end
end
