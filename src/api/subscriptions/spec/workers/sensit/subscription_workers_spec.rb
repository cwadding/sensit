require 'spec_helper'
require File.expand_path("../../../../app/workers/sensit/subscriptions_worker.rb",  __FILE__)
module Sensit
	describe SubscriptionsWorker do

		# def perform(subscription_id)
		# 	# puts subscription_id
		# 	subscription = ::Sensit::Topic::Subscription.where(:id => subscription_id).first
		# 	# puts subscription.inspect
		# 	# client = ::SocketIO.connect(subscription.host) do
		# 	#   before_start do
		# 	#     on_message {|message| puts "incoming message: #{message}"}
		# 	#     on_event(subscription.name) { |data| puts data.first}
		# 	#   end
		# 	# end
			
		# 	EM.run {
		# 		topic_id = subscription.topic_id
		# 	  client = Faye::Client.new(subscription.host)
		# 	# puts "/#{subscription.name}"
		# 	  client.subscribe("/#{subscription.name}") do |feed_params|
		# 	    # {:feed => {:at => Time.now.to_f, :values => {} }}
		# 	    feed = Topic::Feed.create(feed_params["feed"].merge!({index: subscription.user.name, type: topic_id, :topic_id => topic_id})) 
		# 	    # puts feed.inspect
		# 	    # puts feed_params.inspect
		# 	  end
		# 	}
		# end

		before(:each) do
			@worker = SubscriptionsWorker.new
		end

		describe "#perform" do
			context "with a subscription" do
				before(:each) do
					topic = FactoryGirl.create(:topic, user: @user, application: nil)
					@subscription = FactoryGirl.create(:subscription, :topic => topic)					
				end
			end
		end

		describe "#faye_subscribe" do
			context "with a subscription" do
				before(:each) do
					topic = FactoryGirl.create(:topic, user: @user, application: nil)
					@subscription = FactoryGirl.create(:subscription, :topic => topic)					
				end
				it "subscribes using Faye" do
					Faye::Client.any_instance.should_receive(:subscribe).with("/#{@subscription.name}")
					@worker.send(:faye_subscribe,@subscription)
				end
			end
		end
	end
end
