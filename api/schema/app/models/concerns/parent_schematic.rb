# module Sensit
	module ParentSchematic
		extend ::ActiveSupport::Concern
		included do
			delegate :fields, :to => :topic, :prefix => false
		end
	end
# end