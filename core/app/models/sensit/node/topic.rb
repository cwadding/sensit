module Sensit
  class Node::Topic < ActiveRecord::Base
  	belongs_to :node
  	has_many :feeds
  	has_many :fields
  end
end
