# module Sensit
	module Publishable
		extend ::ActiveSupport::Concern
		included do
			before_create :percolate
			after_create :percolate

			def percolate
				response = percolate
				if (response["ok"])
					response["matches"].each do |match|
						faye_broadcast(match)
					end
				end
			end

			def broadcast
				if (response["ok"])
					faye_broadcast
					@new_record = false
					@id = response["_id"]
				end
			end

			def faye_broadcast(channel = nil)
				begin
					channel = self.topic_id if channel.nil?
					at_f = 0
					if (self.at.kind_of?(Numeric))
			    		at_f = self.at
			    	elsif (self.at.kind_of?(Time) || self.at.kind_of?(DateTime))
			    		at_f = self.at.utc.to_f
			    	elsif (self.at.is_a?(String) && /^[\d]+(\.[\d]+){0,1}$/ === self.at)
			    		at_f = self.at.to_f
			    	end
					message = {:channel => channel, :data => {:at => at_f, :data => self.values}, :ext => {:auth_token => ::FAYE_TOKEN}}
					uri = URI.parse("http://localhost:9292/faye")
					Net::HTTP.post_form(uri, :message => message.to_json)
				rescue Errno::ECONNREFUSED => e

				end
			end

		end
	end
# end