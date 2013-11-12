module Sensit
  class Node::Topic::Feed::DataRow < ActiveRecord::Base
  	belongs_to :feed

    validates_associated :feed
	validates :key, presence: true
	validates :value, presence: true
  end
end
