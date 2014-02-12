require 'blather/client/dsl'

module Sensit
	module Messenger
		class XMPP
  			include Blather::DSL

			def publish(channel = nil, data)
				setup(self.username, self.password, self.host, self.port)
				subscription :request? do |s|
  					write_to_stream s.approve!
				end
			end		
  		end
		@@schemes['XMPP'] = XMPP  		
  	end
end
# http://rdoc.info/gems/blather/index
# EM.run { echo.run }