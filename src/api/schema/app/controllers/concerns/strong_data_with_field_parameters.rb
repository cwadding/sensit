# module Sensit
	module StrongDataWithFieldParameters
		extend ::ActiveSupport::Concern
		include GetTopicFields
		included do
			def data_param
				params.permit(fields)
			end
		end
	end
# end