module Sensit
  class Datatype < ActiveRecord::Base
  	has_many :units
  	has_many :fields, :class_name => "Node::Topic::Field"
  end
end
