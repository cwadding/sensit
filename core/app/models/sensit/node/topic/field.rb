module Sensit
  class Node::Topic::Field < ActiveRecord::Base
  	belongs_to :topic
  	belongs_to :unit
  end
end
