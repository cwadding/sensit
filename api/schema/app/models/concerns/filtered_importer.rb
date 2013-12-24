# module Sensit
	module FilteredImporter
		extend ::ActiveSupport::Concern
		included do
    		attr_accessor :fields

			def load_feeds(file)
				feed_arr = []
				spreadsheets = open_spreadsheets(file)
				spreadsheets.each do |spreadsheet|
					header = spreadsheet.shift
					# filter out any rows that are not in the fields
					temp_fields = self.fields.clone
					temp_fields.delete_if {|x| !header.include?(x.key)}

					spreadsheet.each do |row|
						values = temp_fields.inject({}) {|h,field| h.merge!(field.key => field.convert(row[header.index(field.key)]))}
						at = row[header.index("at")]
						tz = row[header.index("tz")]
						feed_arr << ::Sensit::Topic::Feed.new({index: self.index, type: self.type, topic_id: self.topic_id, at: at, tz: tz, values: values})
					end
				end
				feed_arr.uniq {|feed| feed.at}
			end
		end
	end
# end