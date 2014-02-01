# module Sensit
	module Measurable
		extend ::ActiveSupport::Concern
		included do
			belongs_to :unit
		end
	end
# end