module Sensit
  class Topic < ActiveRecord::Base
	extend ::FriendlyId

	friendly_id :name, use: [:slugged, :finders]
  	after_destroy :destroy_feeds
  	belongs_to :user, class_name: "Sensit::User"
  	belongs_to :application, class_name: "::Doorkeeper::Application", foreign_key: "application_id"
	
	validates :name, presence: true, uniqueness: true

	has_many :fields, dependent: :destroy, :class_name => "Sensit::Topic::Field"	

	# delegate :name, :to => :node, :prefix => true

	def feeds(params = {})
		body = params[:body] || {:query => {"match_all" => {  }}}
        sort = params[:sort] || "at:asc"
        per = params[:per] || 10
        from = ((params[:page] || 1)-1) * per
        # Sort is not included right now because it causes an exception when there are no documents in the index
        begin
        	Topic::Feed.search({index: elastic_index_name, type: elastic_type_name, body: body, size: per, from: from})
		rescue Exception => exc
			logger.error("Exception when trying to search for feeds: #{exc.message}")
			[]
		end        	
	end


	def create_mapping
		client = ENV['ELASTICSEARCH_URL'] ? ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL']) : ::Elasticsearch::Client.new
		field_properties = fields.inject({}) do |h, field|
			h.merge!({field.key => field.properties})
			h
		end

		# if there are many fields then add the store function to specific fields that are accessed frequently
		if client.indices.exists(index: elastic_index_name)
			client.indices.put_mapping({index: elastic_index_name, type: elastic_type_name, body:{mapping:{ elastic_type_name => {properties: field_properties}}}})
		else
			client.indices.create({index: elastic_index_name, body:{ mapping:{ elastic_type_name => {properties: field_properties}}}})
		end

		self.is_initialized = true
		self.save		
	# client.indices.create index: 'test',
 #                      body: {
 #                        settings: {
 #                          index: {
 #                            number_of_shards: 1,
 #                            number_of_replicas: 0,
 #                            'routing.allocation.include.name' => 'node-1'
 #                          },
 #                          analysis: {
 #                            filter: {
 #                              ngram: {
 #                                type: 'nGram',
 #                                min_gram: 3,
 #                                max_gram: 25
 #                              }
 #                            },
 #                            analyzer: {
 #                              ngram: {
 #                                tokenizer: 'whitespace',
 #                                filter: ['lowercase', 'stop', 'ngram'],
 #                                type: 'custom'
 #                              },
 #                              ngram_search: {
 #                                tokenizer: 'whitespace',
 #                                filter: ['lowercase', 'stop'],
 #                                type: 'custom'
 #                              }
 #                            }
 #                          }
 #                        },
 #                        mappings: {
 #                          document: {
 #                            properties: {
 #                              title: {
 #                                type: 'multi_field',
 #                                fields: {
 #                                    title:  { type: 'string', analyzer: 'snowball' },
 #                                    exact:  { type: 'string', analyzer: 'keyword' },
 #                                    ngram:  { type: 'string',
 #                                              index_analyzer: 'ngram',
 #                                              search_analyzer: 'ngram_search'
 #                                    }
 #                                }
 #                              }
 #                            }
 #                          }
 #                        }
 #                      }
	end
	
	def destroy_feeds
		# client = ::Elasticsearch::Client.new
		
		# TODO change to delete_by_query when it works properly
		feeds.each do |feed|
			feed.destroy
		end
		# client.delete_by_query({index: elastic_index_name, type: elastic_type_name, body: { query: { term: { topic_id: self.id } } }})
	end

	# lazily create the index in elastic search upon the first addition of any data to a feed
private


	def elastic_index_name
		user.name.parameterize
	end
	def elastic_type_name
		self.to_param
	end   
  end
end