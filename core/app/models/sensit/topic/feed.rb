module Sensit
  class Topic::Feed
  	include ::ActiveModel::Model
  	    #  extend  ActiveModel::Naming
        # extend  ActiveModel::Translation
        # include ActiveModel::Validations
        # include ActiveModel::Conversion
	extend ::ActiveModel::Callbacks
	include ::ActiveModel::Dirty
	# include ElasticUniquenessValidator
  	define_model_callbacks :create, :update, :save

  	attr_accessor :at, :values, :topic_id
	attr_reader :errors, :id, :type, :index

	def initialize(params={})
    	@new_record = true
    	@type = params.delete(:type)
    	@index = params.delete(:index)
    	t = params.delete(:at)
    	if (t.kind_of?(Numeric) || t.kind_of?(Time) || t.kind_of?(DateTime))
    		self.at = Time.zone.at(t)
    	elsif (t.is_a?(String) && /^[\d]+(\.[\d]+){0,1}$/ === t)
    		self.at = Time.zone.at(t.to_f)
    	elsif (t.is_a?(String))
    		self.at = Time.zone.parse(t)
    	end
    	tz = params.delete(:tz)
    	self.at = self.at.in_time_zone(tz) if tz.present? && ::ActiveSupport::TimeZone.zones_map.keys.include?(tz)

    	super(params)
    	@errors = ActiveModel::Errors.new(self)
  	end

	validates :index, presence: true
	validates :type, presence: true
	validates :topic_id, presence: true
	validates :at, presence: true, elastic_uniqueness: {scope: [:topic_id]}
	validates :values, presence: true

  	def self.find(arguments = {})
		result = elastic_client.get arguments
		result.nil? ? nil : map_results(result)
  	end

	def self.search(arguments = {})
		results = elastic_client.search arguments
		results["hits"]["hits"].inject([]) {|arr, result| arr << map_results(result)}
	end

	def self.percolate(arguments = {})
		result = elastic_client.percolate arguments
	end

	def self.count(arguments = {})
		result = elastic_client.count arguments
		result["count"].to_i
	end

	def self.create(arguments = {})
		feed = self.new(arguments)
		feed.send(:create)
		feed
	end

	def self.destroy(arguments = {})
		elastic_client.delete arguments
	end

	def self.destroy_all(arguments = {})
		elastic_client.indices.delete arguments
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
		raise ::Elasticsearch::Transport::Transport::Errors::BadRequest.new if new_record? || id.nil?
		
		self.class.destroy({index: index, type: type, id: id})
	end

	def topic
		@topic ||= Topic.find(self.topic_id)
	end

	def topic=(record)
		raise ::TypeError.new("Not a Topic") unless record.instance_of? Topic
		self.topic_id = record.id
	end

  	delegate :fields, :to => :topic, :prefix => false
	delegate :name, :to => :topic, :prefix => true
	delegate :node_name, :to => :topic, :prefix => false

	# need a custom validation to ensure that the data value is the datatype that is expected based on the field value type and that the key is correct as well

	def validate!
		errors.add(:name, "can not be nil") if name.nil?
	end

	def self.human_attribute_name(attr, options = {})
		"Name"
	end

	def update_attributes(params)
		values.merge!(params)
		save
	end

private

	def self.map_results(result)
		t = result["_source"].delete("at")
		tz = result["_source"].delete("tz")
		at = Time.at(t) unless t.nil?
		topic_id = result["_source"].delete("topic_id")
		body = result["_source"]
		obj = self.new({index: result["_index"], type: result["_type"], at: at, tz: tz, topic_id: topic_id, values: body})
		obj.instance_variable_set(:@id, result["_id"])
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
		body = self.values.clone
		at_f = 0
		if (self.at.kind_of?(Numeric))
    		at_f = self.at
    	elsif (self.at.kind_of?(Time) || self.at.kind_of?(DateTime))
    		at_f = self.at.utc.to_f
    	elsif (self.at.is_a?(String) && /^[\d]+(\.[\d]+){0,1}$/ === self.at)
    		at_f = self.at.to_f
    	end
		body.merge!({at:at_f, tz: (self.at.time_zone.name || "UTC"), topic_id:self.topic_id})
		{index: index, type: type, body: body}
	end

	def attributes_to_update
		at_f = 0
		if (self.at.kind_of?(Numeric))
    		at_f = self.at
    	elsif (self.at.kind_of?(Time) || self.at.kind_of?(DateTime))
    		at_f = self.at.utc.to_f
    	elsif (self.at.is_a?(String) && /^[\d]+(\.[\d]+){0,1}$/ === self.at)
    		at_f = self.at.to_f
    	end
		body = self.values.clone
		body.merge!({at:at_f, tz: self.at.time_zone.name, topic_id:self.topic_id})
		{index: index, type: type, id: id, body: {doc: body} }
	end

	def attributes_for_percolate
		at_f = 0
		if (self.at.kind_of?(Numeric))
    		at_f = self.at
    	elsif (self.at.kind_of?(Time) || self.at.kind_of?(DateTime))
    		at_f = self.at.utc.to_f
    	elsif (self.at.is_a?(String) && /^[\d]+(\.[\d]+){0,1}$/ === self.at)
    		at_f = self.at.to_f
    	end
		body = self.values.clone
		body.merge!({at:at_f, tz: self.at.time_zone.name, topic_id:self.topic_id})
		{index: index, type: type, body: {doc: body} }
	end


	def update
		run_callbacks :update do
			response = elastic_client.update attributes_to_update
			response["ok"] || false
		end
	end

	def percolate
		elastic_client.percolate attributes_for_percolate
	end

	def create
		run_callbacks :create do
			response = percolate
			if (response["ok"])
				response["matches"].each do |match|
					faye_broadcast(match)
				end
			end

			response = elastic_client.create attributes_to_create
			if (response["ok"])
				faye_broadcast
				@new_record = false
				@id = response["_id"]
			end
			response["ok"] || false
		end
	end

	def faye_broadcast(channel = nil)
		begin
			channel = self.topic_id if channel.nil?
			at_f = 0
			if (self.at.kind_of?(Numeric))
	    		at_f = self.at
	    	elsif (self.at.kind_of?(Time) || self.at.kind_of?(DateTime))
	    		at_f = self.at.utc.to_f
	    	elsif (self.at.is_a?(String) && /^[\d]+(\.[\d]+){0,1}$/ === self.at)
	    		at_f = self.at.to_f
	    	end
			message = {:channel => channel, :data => {:at => at_f, :data => self.values}, :ext => {:auth_token => ::FAYE_TOKEN}}
			uri = URI.parse("http://localhost:9292/faye")
			Net::HTTP.post_form(uri, :message => message.to_json)
		rescue Errno::ECONNREFUSED => e

		end
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