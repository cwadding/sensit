module Sensit
  class Node::Topic::Feed
  	include ActiveModel::Model
  	    #  extend  ActiveModel::Naming
        # extend  ActiveModel::Translation
        # include ActiveModel::Validations
        # include ActiveModel::Conversion
	extend ActiveModel::Callbacks
	include ActiveModel::Dirty

  	attr_accessor :at, :data, :topic_id
	attr_reader :errors, :id, :type, :index

	def initialize(params={})
    	@errors = ActiveModel::Errors.new(self)
    	super(params)
  	end

  	define_model_callbacks :create, :update, :destroy, :save

	validates :at, presence: true
	validates :data, presence: true

  	def self.find(arguments = {})
		result = elastic_client.get arguments
		result.nil? ? nil : map_results(result)
  	end

	def self.search(arguments = {})
		results = elastic_client.search arguments
		results.inject([]) {|arr, result| arr << map_results(result)}
	end

	def self.percolate(arguments = {})
		result = elastic_client.percolate arguments
	end

	def self.create(arguments = {})
		run_callbacks :create do
			response = elastic_client.create arguments
		end
	end

	def update(body)
		run_callbacks :update do
			elastic_client.update index: topic_name, type: 'mytype', id: id#, body: import_data
		end
	end

	def save(body)
		run_callbacks :save do
			# Your create action methods here
		end
	end	

	def destroy(body)
		run_callbacks :destroy do
			elastic_client.delete index: topic_name, type: 'mytype', id: id
		end
	end

	def topic
		@topic ||= Node::Topic.find(self.topic_id)
	end

	def topic=(record)
		self.topic_id = record.topic_id
	end

  	delegate :fields, :to => :topic, :prefix => false
	delegate :name, :to => :topic, :prefix => true

	# need a custom validation to ensure that the data value is the datatype that is expected based on the field value type and that the key is correct as well

	def validate!
		errors.add(:name, "can not be nil") if name.nil?
	end

	def self.human_attribute_name(attr, options = {})
		"Name"
	end

private

	def self.map_results(result)
		t = result["_source"].delete("at")
		at = Time.at(t) unless t.nil?
		topic_id = result["_source"].delete("topic_id")
		data = result["_source"]
		obj = self.new({at: at, topic_id: topic_id, data: data})
		obj.instance_variable_set(:@id, result["_id"])
		obj.instance_variable_set(:@index, result["_index"])
		obj.instance_variable_set(:@type, result["_type"])
		obj
	end

	def self.elastic_client
		@client ||= ::Elasticsearch::Client.new log: true
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