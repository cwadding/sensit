# module Sensit
	module Reportable
		extend ::ActiveSupport::Concern
		included do
			has_many :reports, dependent: :destroy, class_name: "Sensit::Topic::Report"
		end
	end
# end