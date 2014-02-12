require 'socket'

module Sensit
	module Messenger
		class UDP < Base

			def subscribe(name, &block)
				s = UDPSocket.new
				s.bind(self.host, self.port)
				s.recvfrom(10)
			end

			def publish(channel = nil, data)
				s = UDPSocket.new
				s.bind(self.host, self.port)
				s.send(data, "0", self.host, self.port)
			end
		end
		@@schemes['UDP'] = UDP	
	end
end