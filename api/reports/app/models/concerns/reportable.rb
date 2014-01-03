# module Sensit
	module Reportable
		extend ::ActiveSupport::Concern
		included do
			has_many :reports, dependent: :destroy
		end
	end
# end