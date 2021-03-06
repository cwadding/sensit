module Sensit
  class Topic::Percolator
  	include ::ActiveModel::Model
  	    #  extend  ActiveModel::Naming
        # extend  ActiveModel::Translation
        # include ActiveModel::Validations
        # include ActiveModel::Conversion
	extend ::ActiveModel::Callbacks
	include ::ActiveModel::Dirty

	define_model_callbacks :create, :update, :save, :destroy

  	attr_accessor :name, :query, :topic_id, :user_id
	attr_reader :errors

	def initialize(params={})
    	@new_record = true
    	super(params)
    	@errors = ActiveModel::Errors.new(self)
  	end

  	# define_model_callbacks :create, :update, :destroy, :save

	validates :user_id, presence: true
	validates :topic_id, presence: true
	validates :name, presence: true
	validates :query, presence: true

  	def self.find(arguments = {})
		user_id, topic_id, name = extract_params_with_name(arguments)
  		# Should make sure that it has a id index and type
		result = elastic_client.get arguments.merge({index: elastic_index_name(user_id), type: type_key(user_id, topic_id), id: name})
		result.nil? ? nil : map_results(result)
  	end

	def self.search(arguments = {})
		user_id, topic_id = extract_params(arguments)
		# Should make sure that it has a id index  and type
		results = elastic_client.search arguments.merge({index: elastic_index_name(user_id), type: type_key(user_id, topic_id)})
		results["hits"]["hits"].inject([]) {|arr, result| arr << map_results(result)}
	end

	def self.count(arguments = {})
		user_id, topic_id = extract_params(arguments)
		result = elastic_client.count arguments.merge({index: elastic_index_name(user_id), type: type_key(user_id, topic_id)})
		result["count"].to_i
	end

	def self.create(arguments = {})
		percolator = self.new(arguments)
		percolator.send(:create)
		percolator
	end

	def self.update(arguments = {})
		percolator = self.new(arguments)
		percolator.send(:update)
		percolator.instance_variable_set(:@new_record, false)
		percolator
	end

	def self.destroy(arguments = {})
		percolator = self.new(arguments)
		percolator.instance_variable_set(:@new_record, false)
		percolator.destroy
	end

	def self.destroy_all(arguments = {})
		user_id, topic_id = extract_params(arguments)
		elastic_client.indices.delete arguments.merge(index: elastic_index_name(user_id), type: type_key(user_id, topic_id))
	end


	def topic=(record)
		self.topic_id = record.to_param
		self.user_id = record.user.name if record.user
	end

	def topic
		@topic ||= Topic.find(self.topic_id)
	end

	def new_record?
		@new_record || false
	end

	def save
		run_callbacks :save do
		valid? ? (new_record? ? create : update) : false
		end
	end	

	def destroy
		raise ::Elasticsearch::Transport::Transport::Errors::BadRequest.new if new_record? || [self.name, self.topic_id, self.user_id].any?(&:nil?)		
		run_callbacks :destroy do
			elastic_client.delete index: elastic_index_name, type: elastic_index_type, id: self.name
		end
	end

	# need a custom validation to ensure that the data value is the datatype that is expected based on the field value type and that the key is correct as well

	# def validate!
	# 	errors.add(:id, "can not be nil") if id.nil?
	# end

	# def self.human_attribute_name(attr, options = {})
	# 	"Name"
	# end

private

	def self.map_results(result)
		user_id, topic_id = result["_type"].split(":")
		obj = self.new({user_id: user_id, topic_id: topic_id, name: result["_id"], query: result["_source"]["query"]})
		obj.instance_variable_set(:@new_record, false)
		obj
	end

	def self.elastic_client
		@@client ||= ENV['ELASTICSEARCH_URL'] ? ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL']) : ::Elasticsearch::Client.new
	end

	def elastic_client
		self.class.elastic_client
	end

	def attributes_to_create
		{index: elastic_index_name, type: elastic_index_type, id: self.name, body: {query: self.query}}
	end

	def attributes_to_update
		{index: elastic_index_name, type: elastic_index_type, id: self.name, body: {doc: {query: self.query}} }
	end


	def update
		run_callbacks :update do
			response = elastic_client.update attributes_to_update
			!response.nil?
		end
	end

	def create
		run_callbacks :create do
			response = elastic_client.create attributes_to_create
			success = response["ok"] || response["created"] || false
			if (success)
				@new_record = false
			end
			success
		end
	end

	def self.elastic_index_name(user_id)
		@@index = Rails.env.test? ? user_id.parameterize : "_percolator"
	end

	def elastic_index_name
		self.class.elastic_index_name(self.user_id)
	end	

	def elastic_index_type
		self.class.type_key(self.user_id, self.topic_id)
	end
	def self.type_key(user_id, topic_id)
		"#{user_id}:#{topic_id}"
	end

	def self.extract_params(params)
		user_id = params.delete(:user_id)
  		topic_id = params.delete(:topic_id)
  		raise ArgumentError, "user_id is required." if user_id.nil?
  		raise ArgumentError, "topic_id is required." if topic_id.nil?
  		[user_id, topic_id]
	end

	def self.extract_params_with_name(params)
		user_id, topic_id = extract_params(params)
  		name = params.delete(:name)
  		raise ArgumentError, "name is required." if name.nil?
  		[user_id, topic_id, name]
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