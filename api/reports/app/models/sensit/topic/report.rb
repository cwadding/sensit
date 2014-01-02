module Sensit
  class Topic::Report < ActiveRecord::Base
  	extend ::FriendlyId
	friendly_id :name, use: [:slugged, :finders]

  	serialize :query, Hash
  	serialize :facets, Hash
  	belongs_to :topic

	validates_associated :topic

	validates :name, presence: true, uniqueness: {scope: :topic_id}
	validates :facets, presence: true


	validate :valid_query

	def valid_query
		response = elastic_client.indices.validate_query(index: self.topic_id, explain: true, body:{query: self.query || {"match_all" => {}},facets: self.facets})
		if response["valid"]
			response["explanations"].each do |explanation|
				errors.add(explanation["index"], explanation["error"]) unless explanation["valid"]
			end
		end
		response["valid"]
	end

	def self.elastic_client
		@@client ||= ::Elasticsearch::Client.new
	end

	def elastic_client
		self.class.elastic_client
	end


  end
end
