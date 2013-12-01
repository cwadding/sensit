require 'SocketIO'
require 'sidekiq'

module Sensit
	class SubscriptionsWorker
		include ::Sidekiq::Worker
		def perform(subscription_id)
			subscription = ::Sensit::Topic::Subscription.find(subscription_id)
			client = ::SocketIO.connect(subscription.host) do
			  before_start do
			    on_message {|message| puts "incoming message: #{message}"}
			    on_event(subscription.name) { |data| puts data.first}
			  end
			end
		end
	end
end