require 'net/http'

module Sensit
	module Messenger
		class HTTP < Base

			def publish(channel = nil, data)
				url = URI(uri)
				req = ::Net::HTTP::Post.new(url)
				req.set_form_data(data)
				req.basic_auth self.username, self.password if self.username

				res = ::Net::HTTP.start(url.hostname, url.port, :use_ssl => url.scheme == 'https') do |http|
				  http.request(req)
				end

				case res
				when Net::HTTPSuccess, Net::HTTPRedirection
				  # OK
				else
				  res.value
				end
			end
		end
	end
end