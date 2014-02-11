# module Sensit
	module PublicationsTopic
		extend ::ActiveSupport::Concern
		included do
			has_many :publications, dependent: :destroy, class_name: "Sensit::Topic::Publication"
		end
	end
# end