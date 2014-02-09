require 'spec_helper'

module Sensit
  describe MQTT do

		describe "#uri=" do
			it "parses the uri and assigns the attributes" do
				mqtt = ::Sensit::MQTT.new
				mqtt.uri = "mqtt://user:pass@broker.cloudmqtt.com:1883"
				mqtt.username.should == "user"
				mqtt.password.should == "pass"
				mqtt.host.should == "broker.cloudmqtt.com"
				mqtt.port.should == 1883
			end
		end
		describe "#uri" do
			it "returns the uri as a string" do
				mqtt = ::Sensit::MQTT.new(username: "user", password: "pass", host: "broker.cloudmqtt.com", port: 1883)
				mqtt.uri.should == "mqtt://user:pass@broker.cloudmqtt.com:1883"
			end
		end	

		describe "#connection_options" do
			it "returns the connection parameters" do
				mqtt = ::Sensit::MQTT.new(username: "user", password: "pass", host: "broker.cloudmqtt.com", port: 1883)
				mqtt.connection_options.should == {remote_host: "broker.cloudmqtt.com",remote_port: 1883, username: "user", password: "pass"}
			end
		end

		describe "#subscribe" do
			it "connects to the server" do
				mqtt = ::Sensit::MQTT.new
				connection_options = {remote_host: "broker.cloudmqtt.com",remote_port: 1883, username: "user", password: "pass"}
				mqtt.stub(:connection_options).and_return(connection_options)
				client = ::MQTT::Client.new
				client.should_receive(:get)
				::MQTT::Client.should_receive(:connect).with(connection_options).and_yield(client)
				mqtt.subscribe(nil)
			end

			# it "receives a message", current:true do
			# 	mqtt = ::Sensit::MQTT.new({host: "localhost",port: 1883})
			# 	block = lambda { |channel, data|  puts "channel: #{channel} data: #{data.inspect}"}
			# 	block.should_receive(:call).with("channel", {"some" => "data"})
			# 	thr = mqtt.subscribe("channel", &block)
			# 	mqtt.publish("channel", {"some" => "data"})
			# end
		end

		describe "#publish" do
			it "sends data to the " do
				mqtt = ::Sensit::MQTT.new
				connection_options = {remote_host: "broker.cloudmqtt.com",remote_port: 1883, username: "user", password: "pass"}
				mqtt.stub(:connection_options).and_return(connection_options)
				client = ::MQTT::Client.new
				client.should_receive(:publish).with("channel", {"some" => "data"})
				::MQTT::Client.should_receive(:connect).with(connection_options).and_yield(client)
				mqtt.publish("channel", {"some" => "data"})
			end
		end

		# def subscribe(name, &block)
		# 	::Thread.new do
		# 		::MQTT::Client.connect(connection_options) do |c|
		# 			# The block will be called when you messages arrive to the topic
		# 			c.get(subscription.name) do |topic, message|
		# 				block.call topic, message
		# 			end
		# 		end
		# 	end
		# end
  end

  describe Subscription do

	it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }

    it { should validate_presence_of(:host) }

	describe "#uri=" do
		it "parses the uri and assigns the attributes" do
			subscription = Subscription.new
			subscription.uri = "mqtt://user:pass@broker.cloudmqtt.com:1883"
			subscription.protocol.should == "mqtt"
			subscription.username.should == "user"
			subscription.password.should == "pass"
			subscription.host.should == "broker.cloudmqtt.com"
			subscription.port.should == 1883
		end
	end
    describe "#uri" do
    	it "returns the uri as a string" do
			subscription = Subscription.new
			subscription.protocol = "mqtt"
			subscription.username = "user"
			subscription.password = "pass"
			subscription.host = "broker.cloudmqtt.com"
			subscription.port = 1883
			subscription.uri.should == "mqtt://user:pass@broker.cloudmqtt.com:1883"
    	end
    end	
  end
end
