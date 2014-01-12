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

	validates_associated :topic, :facets

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
		{index: elastic_index_name, type: elastic_type_name, body: {query: self.query, facets: facets.inject({}){|h, facet| h.merge!(facet.to_query)}}}
	end

	def self.elastic_client
		@@client ||= ::Elasticsearch::Client.new
	end

	def elastic_client
		self.class.elastic_client
	end

	def default_query
		self.query = {:match_all => {}} if self.query.blank?
	end

      def elastic_index_name
        Rails.env.test? ? ELASTIC_SEARCH_INDEX_NAME : params[:topic_id].to_s
      end
      def elastic_type_name
        topic.to_param
      end      


  end
end
