module Sensit
  class Node::Topic < ActiveRecord::Base
  	belongs_to :node
  	has_many :feeds
  	has_many :fields
	
	validates_associated :node
	validates :name, presence: true, uniqueness: {scope: :node_id}

  end
end
