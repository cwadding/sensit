module Sensit
  class Topic::Report < ActiveRecord::Base
  	extend ::FriendlyId
	friendly_id :name, use: [:slugged, :finders]

	after_initialize :default_query

  	serialize :query, Hash
  	belongs_to :topic, class_name: "Sensit::Topic"

	validates :name, presence: true, uniqueness: {scope: :topic_id}

	# validate :valid_query?
	has_many :facets, class_name: "Sensit::Topic::Report::Facet", dependent: :destroy
	has_many :aggregations, class_name: "Sensit::Topic::Report::Aggregation", dependent: :destroy

	validates_associated :topic, :aggregations

	def total
		results["hits"]["total"] || 0
	end

	def results
		@results ||= send_query
	end

	def valid_query?
		response = elastic_client.indices.validate_query(to_search_query.merge!(explain: true))
		unless response["valid"]
			response["explanations"].each do |explanation|
				errors.add(explanation["index"], explanation["error"]) unless explanation["valid"]
			end
		end
		response["valid"]
	end

private

	def send_query
		elastic_client.search(to_search_query.merge!(size: 0))
	end


	def to_search_query
		{index: elastic_index_name, type: elastic_type_name, body: {query: self.query, aggregations: aggregations.inject({}){|h, aggregation| h.merge!(aggregation.to_query)}}}
	end

	def self.elastic_client
		@@client ||= ENV['ELASTICSEARCH_URL'] ? ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL']) : ::Elasticsearch::Client.new
	end

	def elastic_client
		self.class.elastic_client
	end

	def default_query
		self.query = {:match_all => {}} if self.query.blank?
	end

	def elastic_index_name
		self.topic.user.name.parameterize
	end

	def elastic_type_name
		self.topic.to_param
	end


  end
end
