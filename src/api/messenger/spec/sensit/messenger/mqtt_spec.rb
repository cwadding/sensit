require 'spec_helper'

module Sensit
	module Messenger
		describe MQTT do

			describe "#connection_options" do
				it "returns the connection parameters" do
					mqtt = ::Sensit::Messenger::MQTT.new(username: "user", password: "pass", host: "broker.cloudmqtt.com", port: 1883)
					mqtt.connection_options.should == {remote_host: "broker.cloudmqtt.com",remote_port: 1883, username: "user", password: "pass"}
				end
			end

			describe "#subscribe" do
				it "connects to the server" do
					mqtt = ::Sensit::Messenger::MQTT.new
					connection_options = {remote_host: "broker.cloudmqtt.com",remote_port: 1883, username: "user", password: "pass"}
					mqtt.stub(:connection_options).and_return(connection_options)
					client = ::MQTT::Client.new
					client.should_receive(:get)
					::MQTT::Client.should_receive(:connect).with(connection_options).and_yield(client)
					mqtt.subscribe(nil)
				end

				# it "receives a message" do
				# 	mqtt = ::Sensit::Messenger::MQTT.new({host: "localhost",port: 1883})
				# 	block = Proc.new { |channel, data|  puts "channel: #{channel} data: #{data.inspect}"}
				# 	block.should_receive(:call)
				# 	thr = mqtt.subscribe("channel", &block)
				# 	mqtt.publish("channel", {"some" => "data"})
				# 	sleep(2)
				# end
			end

			describe "#publish" do
				it "sends data to the " do
					mqtt = ::Sensit::Messenger::MQTT.new
					connection_options = {remote_host: "broker.cloudmqtt.com",remote_port: 1883, username: "user", password: "pass"}
					mqtt.stub(:connection_options).and_return(connection_options)
					client = ::MQTT::Client.new
					client.should_receive(:publish).with("channel", {"some" => "data"})
					::MQTT::Client.should_receive(:connect).with(connection_options).and_yield(client)
					mqtt.publish("channel", {"some" => "data"})
				end
			end
		end
	end
end