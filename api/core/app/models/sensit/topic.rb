module Sensit
  class Topic < ActiveRecord::Base
	extend ::FriendlyId

	friendly_id :name, use: [:slugged, :finders]
  	after_destroy :destroy_feeds

	
	validates :name, presence: true, uniqueness: true

	delegate :name, :to => :node, :prefix => true

	def feeds(params = nil)
		body = params[:body] || {:query => {"match_all" => {  }}}
        sort = params[:sort] || "at:asc"
        per = params[:per] || 10
        from = ((params[:page]-1) || 0) * per
        Topic::Feed.search({index: elastic_index_name, type: elastic_type_name, body: body, sort: sort, size: per, from: from})
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

	def elastic_index_name
		Rails.env.test? ? ELASTIC_SEARCH_INDEX_NAME : self.id.to_s
	end
	def elastic_type_name
		Rails.env.test? ? ELASTIC_SEARCH_INDEX_TYPE : self.id.to_s
	end   
  end
end