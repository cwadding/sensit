# module Sensit
	module SensibleApplication
		extend ::ActiveSupport::Concern
		included do
			has_many :topics, :dependent => :destroy, class_name: "Sensit::Topic", foreign_key: "application_id"
		end
	end
# end