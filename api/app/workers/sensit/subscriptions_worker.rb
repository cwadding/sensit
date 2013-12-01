# require 'SocketIO'
require 'sidekiq'
require 'em-websocket'

module Sensit
	class SubscriptionsWorker
		include ::Sidekiq::Worker
		def perform(subscription_id)
			subscription = ::Sensit::Topic::Subscription.find(subscription_id)
			host, port = subscription.host.split(":")
			EventMachine::WebSocket.start(:host => host, :port => port.to_i) do |ws|
				ws.onopen {
					puts "WebSocket connection open"

					# # publish message to the client
					# ws.send "Hello Client"
				}

				ws.onclose { puts "Connection closed" }
				ws.onmessage { |msg|
					puts "Recieved message: #{msg}"
					ws.send "Pong: #{msg}"
				}
			end
		end
	end
end