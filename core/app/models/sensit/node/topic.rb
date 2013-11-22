module Sensit
  class Node::Topic < ActiveRecord::Base

  	after_destroy :destroy_feeds

  	belongs_to :node
  	# has_many :feeds, dependent: :destroy
  	has_many :fields, dependent: :destroy
	
	validates_associated :node
	validates :name, presence: true, uniqueness: {scope: :node_id}

	delegate :name, :to => :node, :prefix => true

	def feeds(params = nil)
		
      if params.nil?
        Node::Topic::Feed.search({index: elastic_index_name, type: elastic_type_name, body: { query: { term: { topic_id: self.id } } }})
      else
		params.deep_merge!({ query: { term: { topic_id: self.id } } })
        Node::Topic::Feed.search({index: elastic_index_name, type: elastic_type_name, body: params})
      end
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
		# elastic_client.
	end

	def elastic_index_name
		Rails.env.test? ? ELASTIC_SEARCH_INDEX_NAME : self.node_id.to_s
	end
	def elastic_type_name
		Rails.env.test? ? ELASTIC_SEARCH_INDEX_TYPE : self.id.to_s
	end   
  end
end