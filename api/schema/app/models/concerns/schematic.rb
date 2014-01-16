# module Sensit
	module Schematic
		extend ::ActiveSupport::Concern
		included do
			has_many :fields, dependent: :destroy, :class_name => "Sensit::Topic::Field"
		end
	end
# end