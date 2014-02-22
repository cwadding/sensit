module Sensit
	class ElasticUniquenessValidator < ::ActiveModel::EachValidator

		def initialize(options)
			if options[:conditions] && !options[:conditions].respond_to?(:call)
			raise ArgumentError, "#{options[:conditions]} was passed as :conditions but is not callable. " \
				"Pass a callable instead: `conditions: -> { where(approved: true) }`"
			end
			super({ case_sensitive: true }.merge!(options))
			@klass = options[:class]
		end

		def validate_each(record, attribute, value)
			if record.new_record?
				client = ENV['ELASTICSEARCH_URL'] ? ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL']) : ::Elasticsearch::Client.new			
				# TODO need to refine query to include scope
				value = value.to_f if value.is_a? Time
				response = client.count(index: record.index, type: record.type, body: { query: { term: { attribute => value } } })
				if response["count"].to_i > 0
					record.errors[attribute] << (options[:message] || "is not unique")
				end
			end
		end
	end
end