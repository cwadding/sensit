# module Sensit
	module Percolatable
		extend ::ActiveSupport::Concern
		included do
			def percolations
				Topic::Precolator.search({type: elastic_type_name})
			end

			def destroy_perclations
				client = ::Elasticsearch::Client.new

				# TODO change to delete_by_query when it works properly
				# feeds.each do |feed|
				# 	feed.destroy
				# end
				# client.delete_by_query({index: elastic_index_name, type: elastic_type_name, body: { query: { term: { topic_id: self.id } } }})
			end
		end
	end
# end