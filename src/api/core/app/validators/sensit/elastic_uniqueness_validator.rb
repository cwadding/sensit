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
			client = ::Elasticsearch::Client.new
			# TODO need to refine query to include scope
			response = client.count(index: record.index, type: record.type, body: { match: { term: { attribute => value } } })
			if response["count"].to_i > 0
				record.errors[attribute] << (options[:message] || "is not unique")
			end
		end
	end
end