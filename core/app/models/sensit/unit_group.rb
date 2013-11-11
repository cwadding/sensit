module Sensit
  class UnitGroup < ActiveRecord::Base
  	has_many :units, :foreign_key => "group_id"
  end
end
