require 'mqtt'

module Sensit
	module Messenger	
		class MQTT < Base
			attr_accessor :host, :port, :username, :password

			def initialize(params = {})
				params.each do |attr, value|
					self.public_send("#{attr}=", value)
				end if params
				super()
			end

			def uri=(value)
				url = ::URI.parse value
				self.host = url.host
				self.port = url.port
				self.username = url.user
				self.password = url.password
			end

			def uri
				if (self.username)
					"mqtt://#{self.username}:#{self.password}@#{self.host}:#{self.port}"
				else
					"mqtt://#{self.host}:#{self.port}"
				end
			end

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
				code_block = block
				::Thread.new do
					::MQTT::Client.connect(connect_opts) do |c|
						c.get(channel) do |topic, message|
							code_block.call topic, message
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
	end
end