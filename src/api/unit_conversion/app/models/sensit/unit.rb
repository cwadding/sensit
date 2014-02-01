module Sensit
  class Unit < ActiveRecord::Base
  	belongs_to :group, :class_name => "UnitGroup"
  	has_many :fields, :class_name => "Topic::Field"
  end
end
