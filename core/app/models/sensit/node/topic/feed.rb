module Sensit
  class Node::Topic::Feed < ActiveRecord::Base
  	belongs_to :topic
  	has_many :data_rows

  	delegate :fields, :to => :topic

  end
end
