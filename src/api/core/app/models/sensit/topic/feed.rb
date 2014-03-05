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
  	define_model_callbacks :create, :update, :save, :destroy

  	attr_accessor :at, :type, :index, :fields
	attr_reader :errors, :id, :data

	def initialize(params={})
    	@new_record = true
    	@type = params.delete(:type)
    	@index = params.delete(:index)
    	t = params.delete(:at)
    	self.at = self.class.convert_to_time(t || Time.now)
    	extracted_fields = params.delete(:fields)
    	self.fields = extracted_fields.nil? ? (self.topic.nil? ? [] : topic.fields) : extracted_fields
    	tz = params.delete(:tz)
    	self.at = self.at.in_time_zone(tz) if self.at.present? && tz.present? && ::ActiveSupport::TimeZone.zones_map.keys.include?(tz)
    	super(params)
		convert_rawdata_to_datatype unless self.data.blank?
    	@errors = ActiveModel::Errors.new(self)
  	end

	validates :index, presence: true
	validates :type, presence: true
	# validates :at, presence: true, elastic_uniqueness: {scope: [:topic_id]}
	validates :at, presence: true
	validates :data, presence: true

	def data=(value)
 		@data = ActiveSupport::HashWithIndifferentAccess.new(value)
	end

  	def self.find(arguments = {})
		result = elastic_client.get arguments
		fields = Topic::Field.joins(:topic).where(sensit_topics:{slug: arguments[:type]}).load if arguments[:type]
		result.nil? ? nil : map_results(result, fields)
  	end

	def self.search(arguments = {})
		results = elastic_client.search arguments
		fields = Topic::Field.joins(:topic).where(sensit_topics:{slug: arguments[:type]}).load if arguments[:type]
		results["hits"]["hits"].inject([]) {|arr, result| arr << map_results(result, fields)}
	end

	def self.percolate(arguments = {})
		# result = elastic_client.percolate arguments
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
		id = arguments.delete(:id)
		feed = self.new(arguments.merge!(fields: []))
		feed.instance_variable_set(:@id, id)
		feed.instance_variable_set(:@new_record, false)
		feed.destroy
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
		run_callbacks :destroy do
			elastic_client.delete({index: self.index, type: self.type, id: self.id}) #if elastic_client.exists({index: self.index, id: self.id})
		end
	end

	def percolate
		# elastic_client.percolate attributes_for_percolate
	end

	def topic
		@topic ||= Topic.find_by(slug: self.type)
	end

	def topic=(record)
		raise ::TypeError.new("Not a Topic") unless record.instance_of? Topic
		self.type = record.id
	end

	delegate :name, :to => :topic, :prefix => true
	delegate :node_name, :to => :topic, :prefix => false
	delegate :ttl, :to => :topic, :prefix => false

	# need a custom validation to ensure that the data value is the datatype that is expected based on the field value type and that the key is correct as well

	# def validate!
	# 	errors.add(:name, "can not be nil") if name.nil?
	# end

	# def self.human_attribute_name(attr, options = {})
	# 	"Name"
	# end

	def update_attributes(params)
		self.data.merge!(params)
		save
	end

	def to_hash
		body = self.data.clone
		body.merge!({at:self.at.to_f, tz: (self.at.time_zone.name || "UTC")})
	end

private

	def self.map_results(result, fields)
		t = result["_source"].delete("at")
		tz = result["_source"].delete("tz")
		at = Time.at(t) unless t.nil?
		body = result["_source"]
		obj = self.new({index: result["_index"], type: result["_type"], at: at, tz: tz, data: body, fields:fields})
		obj.instance_variable_set(:@id, result["_id"])
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
		{index: index, type: type, body: self.to_hash}
	end

	def attributes_to_update
		{index: index, type: type, id: id, body: {doc: self.to_hash} }
	end

	def attributes_for_percolate
		{index: index, type: type, body: {doc: self.to_hash} }
	end

	def update
		run_callbacks :update do
			response = elastic_client.update attributes_to_update
			!response.nil?
		end
	end

	def create
		run_callbacks :create do
			if topic && !topic.is_initialized
				data.each_pair do |key, value|
					field = self.fields.find_or_initialize_by(key: key.to_s.parameterize)
					field.name = key.to_s if field.name.blank?
					field.datatype = field.guess_datatype(value) if field.datatype.nil?
					field.save
				end
				topic.create_mapping
				convert_rawdata_to_datatype
			end
			response = elastic_client.create attributes_to_create
			success = response["ok"] || response["created"] || false
			if (success)
				@new_record = false
				@id = response["_id"]
			end
			success
		end
	end

	def self.convert_to_time(value)
		if (value.kind_of?(Numeric) || value.kind_of?(Time) || value.kind_of?(DateTime))
			Time.zone.at(value)
		elsif (value.is_a?(String) && /^[\d]+(\.[\d]+){0,1}$/ === value)
			Time.zone.at(value.to_f)
		else
			Time.zone.parse(value)
		end
	end

	def convert_rawdata_to_datatype
		self.fields.each do |field|
			self.data[field.key] = Topic::Field.convert(self.data[field.key], field.datatype) if self.data.has_key?(field.key)
		end unless self.fields.nil?
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