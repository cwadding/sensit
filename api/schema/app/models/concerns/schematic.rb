# module Sensit
	module Schematic
		extend ::ActiveSupport::Concern
		included do
			has_many :fields, dependent: :destroy
		end
	end
# end