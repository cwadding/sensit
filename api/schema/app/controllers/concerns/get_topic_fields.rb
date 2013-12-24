# module Sensit
	module GetTopicFields
		extend ::ActiveSupport::Concern
		included do
	      def fields
	        @fields ||= topic.fields
	      end
	      def topic
	      	@topic ||= ::Sensit::Topic.find(params[:topic_id])
	      end
		end
	end
# end