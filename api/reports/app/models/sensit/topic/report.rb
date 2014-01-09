module Sensit
  class Topic::Report < ActiveRecord::Base
  	extend ::FriendlyId
	friendly_id :name, use: [:slugged, :finders]

	after_initialize :default_query

  	serialize :query, Hash
  	belongs_to :topic, class_name: "Sensit::Topic"

	validates_associated :topic

	validates :name, presence: true, uniqueness: {scope: :topic_id}

	# validate :valid_query
	has_many :facets, class_name: "Sensit::Topic::Report::Facet", dependent: :destroy


	def valid_query
		response = elastic_client.indices.validate_query(index: self.topic_id, explain: true, body:{query: self.query , facets: self.facets})
		unless response["valid"]
			response["explanations"].each do |explanation|
				errors.add(explanation["index"], explanation["error"]) unless explanation["valid"]
			end
		end
		response["valid"]
	end

private

	def self.elastic_client
		@@client ||= ::Elasticsearch::Client.new
	end

	def elastic_client
		self.class.elastic_client
	end

	def default_query
		self.query = {:match_all => {}} if self.query.blank?
	end

  end
end
