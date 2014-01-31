# require 'faye'
require 'faye'
require 'eventmachine'
# require 'json'
require 'sidekiq'

module Sensit
	class SubscriptionsWorker
		include ::Sidekiq::Worker
		def perform(params)
			
			subscription = ::Sensit::Topic::Subscription.where(:id => params[:subscription_id]).first
			
			# client = ::SocketIO.connect(subscription.host) do
			#   before_start do
			#     on_message {|message| puts "incoming message: #{message}"}
			#     on_event(subscription.name) { |data| puts data.first}
			#   end
			# end
			
			EM.run do
				faye_subscribe(subscription)
			end
		end

		private

		def faye_subscribe(subscription)
			topic_id = subscription.topic_id
			client = Faye::Client.new(subscription.host)
			
			client.subscribe("/#{subscription.name}") do |feed_params|
				create_feed(feed_params["feed"].merge!({index: subscription.user.name, type: topic_id, :topic_id => topic_id}))
			end
		end

		def create_feed(feed_params)
			feed = Topic::Feed.create(feed_params) 
		end
	end
end