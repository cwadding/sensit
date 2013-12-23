# require 'faye'
require 'faye'
require 'eventmachine'
# require 'json'
require 'sidekiq'

module Sensit
	class SubscriptionsWorker
		include ::Sidekiq::Worker
		def perform(subscription_id)
			# puts subscription_id
			subscription = ::Sensit::Topic::Subscription.where(:id => subscription_id).first
			# puts subscription.inspect
			# client = ::SocketIO.connect(subscription.host) do
			#   before_start do
			#     on_message {|message| puts "incoming message: #{message}"}
			#     on_event(subscription.name) { |data| puts data.first}
			#   end
			# end
			
			EM.run {
				topic_id = subscription.topic_id
			  client = Faye::Client.new(subscription.host)
			# puts "/#{subscription.name}"
			  client.subscribe("/#{subscription.name}") do |feed_params|
			    # {:feed => {:at => Time.now.to_f, :values => {} }}
			    feed = Topic::Feed.create(feed_params["feed"].merge!({index: topic_id, type: topic_id, :topic_id => topic_id})) 
			    # puts feed.inspect
			    # puts feed_params.inspect
			  end

			}
		end
	end
end