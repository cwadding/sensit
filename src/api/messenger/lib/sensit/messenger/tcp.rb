require 'socket'

module Sensit
	module Messenger
		class TCP < Base

			def subscribe(name, &block)
				server = TCPServer.new self.host, self.port
				Thread.new do
					loop do
						Thread.start(server.accept) do |client|
							while line = client.gets # Read lines from socket
								block.call name, line
							end
							client.close
						end
					end
				end
			end

			def publish(channel = nil, data)
				s = TCPSocket.new(self.host, self.port)
				s.puts data
				s.close				
			end
		end
		@@schemes['TCP'] = TCP
	end
end