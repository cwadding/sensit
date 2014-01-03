# module Sensit
	module StrongFeedWithFieldParameters
		extend ::ActiveSupport::Concern
		include GetTopicFields
		included do
			# POST /topic/1/feeds
			def create
				if params.has_key?(:feeds)
					importer = ::Sensit::Topic::Feed::Importer.new({index: elastic_index_name, type: elastic_type_name, :topic_id => topic.id, :fields => fields, :feeds => feeds_params})
					@feeds = importer.feeds
					if importer.save
						@fields = fields
						respond_with(@feeds,:status => 200, :template => "sensit/feeds/index")
					else
						render(:json => "{\"errors\":#{importer.errors.to_json}}", :status => :unprocessable_entity)
					end
				else
					@feed = ::Sensit::Topic::Feed.new(feed_params.merge!({index: elastic_index_name, type: elastic_type_name, :topic_id => topic.id})) 
					if @feed.save
						respond_with(@feed,:status => 200, :template => "sensit/feeds/show")
					else
						render(:json => "{\"errors\":#{@feed.errors.to_json}}", :status => :unprocessable_entity)
					end
				end
			end

			def feed_params
				params.require(:feed).permit(:at, :tz, :values => fields.map(&:key))
			end

			def feeds_params
				values = fields.map(&:key)
				if params[:feeds] && params[:feeds].is_a?(Hash)
					params.require(:feeds).map do |p|
						::ActionController::Parameters.new(p.to_hash).permit(:at, :tz, :values => values)
					end
				else
					params.require(:feeds)
				end
			end
		end
	end
# end