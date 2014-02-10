require 'spec_helper'

module Sensit
	module Messenger
		describe TCP do

			describe "#subscribe" do
				# it "connects to the server", current:true do
				# 	tcp = ::Sensit::Messenger::TCP.new(host: 'localhost', port:2000)
				# 	block = Proc.new { |channel, data|  puts "channel: #{channel} data: #{data.inspect}"}
				# 	block.should_receive(:call).with("hello", {"some"=> "data"})
				# 	thr = tcp.subscribe("hello", &block)
				# 	tcp.publish("hello", {"some"=> "data"})
				# 	Thread.kill(thr) if thr.alive?
				# end

				# it "receives a message", current:true do
				# 	mqtt = ::Sensit::MQTT.new({host: "localhost",port: 1883})
				# 	block = Proc.new { |channel, data|  puts "channel: #{channel} data: #{data.inspect}"}
				# 	block.should_receive(:call).with("channel", {"some" => "data"})
				# 	thr = mqtt.subscribe("channel", &block)
				# 	mqtt.publish("channel", {"some" => "data"})
				# end
			end

			# describe "#publish" do
			# 	it "sends data to the " do
			# 		tcp = ::Sensit::Messenger::TCP.new
			# 		tcp.publish("channel", {"some" => "data"})
			# 	end
			# end
		end
	end
end