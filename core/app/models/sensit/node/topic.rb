module Sensit
  class Node::Topic < ActiveRecord::Base

  	after_destroy :destroy_feeds

  	belongs_to :node
  	# has_many :feeds, dependent: :destroy
  	has_many :fields, dependent: :destroy
	
	validates_associated :node
	validates :name, presence: true, uniqueness: {scope: :node_id}

	delegate :name, :to => :node, :prefix => true

	def feeds
		@feeds ||= Node::Topic::Feed.search({index: node_name, type: name, body: { query: { term: { topic_id: self.id } } }})
	end

	# lazily create the index in elastic search upon the first addition of any data to a feed
private
	def destroy_feeds
		# elastic_client.
	end
  end
end