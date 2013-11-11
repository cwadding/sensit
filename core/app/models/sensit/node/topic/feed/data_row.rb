module Sensit
  class Node::Topic::Feed::DataRow < ActiveRecord::Base
  	belongs_to :feed
  end
end
