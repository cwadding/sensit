module Sensit
  class Topic < ActiveRecord::Base

  	after_destroy :destroy_feeds

  	# has_many :feeds, dependent: :destroy
  	has_many :fields, dependent: :destroy
  	has_many :reports, dependent: :destroy
  	has_many :subscriptions, dependent: :destroy
	

	belongs_to :api_key
	
	validates :name, presence: true, uniqueness:  {scope: :api_key_id}

	delegate :name, :to => :node, :prefix => true

	def feeds(params = nil)
		
      if params.nil?
        Topic::Feed.search({index: elastic_index_name, type: elastic_type_name, body: { query: { term: { topic_id: self.id } } }})
      else
		params.deep_merge!({ query: { term: { topic_id: self.id } } })
        Topic::Feed.search({index: elastic_index_name, type: elastic_type_name, body: params})
      end
	end

	def percolations
        Topic::Precolator.search({type: elastic_type_name})
	end

	def create_index
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

	# lazily create the index in elastic search upon the first addition of any data to a feed
private
	def destroy_feeds
		client = ::Elasticsearch::Client.new

		# TODO change to delete_by_query when it works properly
		feeds.each do |feed|
			feed.destroy
		end
		# client.delete_by_query({index: elastic_index_name, type: elastic_type_name, body: { query: { term: { topic_id: self.id } } }})
	end

	def destroy_perclations
		client = ::Elasticsearch::Client.new

		# TODO change to delete_by_query when it works properly
		# feeds.each do |feed|
		# 	feed.destroy
		# end
		# client.delete_by_query({index: elastic_index_name, type: elastic_type_name, body: { query: { term: { topic_id: self.id } } }})
	end

	def elastic_index_name
		Rails.env.test? ? ELASTIC_SEARCH_INDEX_NAME : self.id.to_s
	end
	def elastic_type_name
		Rails.env.test? ? ELASTIC_SEARCH_INDEX_TYPE : self.id.to_s
	end   
  end
end