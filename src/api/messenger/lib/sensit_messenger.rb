require "sensit_messenger/version"
require 'sensit/messenger/base'

module Sensit
	module Messenger
		autoload :HTTP,'sensit/messenger/http'
		autoload :MQTT,'sensit/messenger/mqtt'
		autoload :TCP,'sensit/messenger/tcp'
		autoload :UDP,'sensit/messenger/udp'
		# autoload :UDP,'sensit/messenger/udp'
	end
end