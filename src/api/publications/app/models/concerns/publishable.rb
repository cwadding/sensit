# module Sensit
	module Publishable
		extend ::ActiveSupport::Concern
		included do
			before_create :broadcast_matches
			after_create :broadcast_create

			def mqtt_connections_opts
				uri = URI.parse ENV['MQTT_URL']
				{
					remote_host: uri.host,
					remote_port: uri.port,
					username: uri.user,
					password: uri.password,
				}
			end


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

			def mqtt_publish(channel = nil)
				MQTT::Client.connect(conn_opts) do |c|
					c.publish(channel, {:at => self.at.utc.strftime("%Y-%m-%dT%H:%M:%S.%3NZ"), :data => self.values})
				end
			end

		end
	end
# end