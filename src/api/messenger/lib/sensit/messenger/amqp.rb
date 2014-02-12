require 'amqp'

module Sensit
	module Messenger	
		class AMQP < Base
			def connection_options
				{
					host: self.host,
					port: self.port,
					username: self.username,
					password: self.password,
				}
			end

			def subscribe(name, &block)
				::EventMachine.run do
					::AMQP.connect(self.uri) do |connection|
						channel  = AMQP::Channel.new(connection)
						channel.queue("amqpgem.examples.hello_world", :auto_delete => true).subscribe do |metadata, payload|
							connection.close {
								EventMachine.stop { exit }
							}
						end
					end
				end
			end

			def publish(channel = nil, data)
				connection ::AMQP.connect(:host => '127.0.0.1')
				channel = AMQP::Channel.new(connection)
				exchange = channel.default_exchange
				exchange.publish(data)
			end		

		end
		@@schemes['AMQP'] = AMQP
	end
end