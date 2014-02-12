require 'mqtt'

module Sensit
	module Messenger	
		class MQTT < Base
			def connection_options
				{
					remote_host: self.host,
					remote_port: self.port,
					username: self.username,
					password: self.password,
				}
			end

			def subscribe(name, &block)
				channel = name
				connect_opts = connection_options
				::Thread.new do
					::MQTT::Client.connect(connect_opts) do |c|
						c.get(channel) do |topic, message|
							block.call topic, message
						end
					end
				end
			end

			def publish(channel = nil, data)
				::MQTT::Client.connect(connection_options) do |c|
					c.publish(channel, data)
				end
			end		

		end
		@@schemes['MQTT'] = MQTT
	end
end