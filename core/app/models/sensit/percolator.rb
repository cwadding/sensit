module Sensit
  class Percolator
  	include ::ActiveModel::Model
  	    #  extend  ActiveModel::Naming
        # extend  ActiveModel::Translation
        # include ActiveModel::Validations
        # include ActiveModel::Conversion
	extend ::ActiveModel::Callbacks
	include ::ActiveModel::Dirty

  	attr_accessor :id, :body, :type
	attr_reader :errors

	def initialize(params={})
    	@new_record = true
    	super(params)
    	@errors = ActiveModel::Errors.new(self)
  	end

  	# define_model_callbacks :create, :update, :destroy, :save

	validates :type, presence: true
	validates :id, presence: true
	validates :body, presence: true

  	def self.find(arguments = {})
  		# Should make sure that it has a id index  and type
		result = elastic_client.get arguments.merge({index: elastic_index_name})
		result.nil? ? nil : map_results(result)
  	end

	def self.search(arguments = {})
		# Should make sure that it has a id index  and type
		results = elastic_client.search arguments.merge({index: elastic_index_name})
		results["hits"]["hits"].inject([]) {|arr, result| arr << map_results(result)}
	end

	def self.count(arguments = {})
		result = elastic_client.count arguments.merge({index: elastic_index_name})
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
		# run_callbacks :destroy do
			elastic_client.delete arguments.merge(index: elastic_index_name)
		# end
	end

	def self.destroy_all(arguments = {})
		# run_callbacks :destroy do
			elastic_client.indices.delete arguments.merge(index: elastic_index_name)
		# end
	end

	def new_record?
		@new_record || false
	end

	def save
		# run_callbacks :save do
		valid? ? (new_record? ? create : update) : false
		# end
	end	

	def destroy
		raise ::Elasticsearch::Transport::Transport::Errors::BadRequest.new if new_record? || id.nil?
		
		self.class.destroy({index: elastic_index_name, type: type, id: id})
	end

	# need a custom validation to ensure that the data value is the datatype that is expected based on the field value type and that the key is correct as well

	def validate!
		errors.add(:id, "can not be nil") if id.nil?
	end

	def self.human_attribute_name(attr, options = {})
		"Name"
	end

	def update_attributes(params)
		body = params
		save
	end

private

	def self.map_results(result)
		obj = self.new({type: result["_type"], id: result["_id"], body: result["_source"]})
		obj.instance_variable_set(:@new_record, false)
		obj
	end

	def self.elastic_client
		@@client ||= ::Elasticsearch::Client.new
	end

	def elastic_client
		self.class.elastic_client
	end

	def attributes_to_create
		{index: elastic_index_name, type: type, id: id, body: body}
	end

	def attributes_to_update
		{index: elastic_index_name, type: type, id: id, body: {doc: body} }
	end


	def update
		response = elastic_client.update attributes_to_update
		response["ok"] || false
	end

	def create
		# run_callbacks :create do
		response = elastic_client.create attributes_to_create
		if (response["ok"])
			@new_record = false
		end
		# end
		response["ok"]
	end

	def self.elastic_index_name
		@@index ||= Rails.env.test? ? ELASTIC_SEARCH_INDEX_NAME : "_percolator"
	end

	def elastic_index_name
		self.class.elastic_index_name
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