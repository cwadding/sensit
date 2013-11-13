module Sensit
  class Node::Topic::Feed < ActiveRecord::Base
  	before_create :add_data
	before_update :update_data
	after_destroy :delete_data

  	belongs_to :topic
  	has_many :data_rows, dependent: :destroy

  	delegate :fields, :to => :topic, :prefix => false
	
	delegate :name, :to => :topic, :prefix => true
	# need a custom validation to ensure that the data value is the datatype that is expected based on the field value type and that the key is correct as well
	
	validates_associated :topic
	validates :at, presence: true

	def data_row
		#elastic_client.get index: topic_name, type: 'mytype', id: self.id
	end

	def data_count(body = {})
		#elastic_client.count index: topic_name, body: body
	end

	def self.percolate(body = {})
		#elastic_client.percolate index: name, body: body
	end
	
	def self.search(body = {})
		#elastic_client.search index: name, body: body
	end

private
	def add_data()
		#elastic_client.create index: topic_name, type: 'mytype', id: id#, body: import_data
	end

	def update_data()
		#elastic_client.update index: topic_name, type: 'mytype', id: id#, body: import_data
	end

	def delete_data()
		#elastic_client.delete index: topic_name, type: 'mytype', id: id
	end

	def self.elastic_client
		#@client ||= Elasticsearch::Client.new log: true
	end
  end
end

# Lazily create the index
# Usage
# client = Elasticsearch::Client.new log: true

# client.index  index: 'myindex', type: 'mytype', id: 1, body: { title: 'Test' }
# # => {"ok"=>true, "_index"=>"myindex", ...}

# client.search body: { query: { match: { title: 'test' } } }
# # => {"took"=>2, ..., "hits"=>{"total":5, ...}}


# Custom Client

# require 'multi_json'
# require 'faraday'
# require 'elasticsearch/api'

# class MySimpleClient
#   include Elasticsearch::API

#   CONNECTION = ::Faraday::Connection.new url: 'http://localhost:9200'

#   def perform_request(method, path, params, body)
#     puts "--> #{method.upcase} #{path} #{params} #{body}"

#     CONNECTION.run_request \
#       method.downcase.to_sym,
#       path,
#       ( body ? MultiJson.dump(body): nil ),
#       {'Content-Type' => 'application/json'}
#   end
# end