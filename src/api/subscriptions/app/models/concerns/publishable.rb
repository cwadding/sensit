# module Sensit
	module Publishable
		extend ::ActiveSupport::Concern
		included do
			# before_create :broadcast_matches
			# after_create :broadcast_create

			def broadcast_matches
				response = percolate
				if (response && response["ok"])
					response["matches"].each do |match|
						faye_broadcast(match)
					end
				end
			end

			def broadcast_create
				if (self.id.present?)
					faye_broadcast
				end
			end

			def faye_broadcast(channel = nil)
				begin
					channel = self.type if channel.nil?
					message = {:channel => channel, :data => {:at => self.at.utc.strftime("%Y-%m-%dT%H:%M:%S.%3NZ"), :data => self.values}, :ext => {:auth_token => ::FAYE_TOKEN}}
					uri = URI.parse("http://localhost:9292/faye")
					Net::HTTP.post_form(uri, :message => message.to_json)
				rescue Errno::ECONNREFUSED => e

				end
			end

		end
	end
# end