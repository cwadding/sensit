module Sensit
  class Node::Topic < ActiveRecord::Base

  	after_destroy :delete_index

  	belongs_to :node
  	has_many :feeds, dependent: :destroy
  	has_many :fields, dependent: :destroy
	
	validates_associated :node
	validates :name, presence: true, uniqueness: {scope: :node_id}

	# lazily create the index in elastic search upon the first addition of any data to a feed
private
	def delete_index
		# elastic_client.
	end

	def elastic_client
		#@client ||= Elasticsearch::Client.new log: true
	end
  end
end