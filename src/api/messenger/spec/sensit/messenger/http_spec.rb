require 'spec_helper'

module Sensit
	module Messenger
		describe HTTP do

			describe "#publish" do
				it "sends data to the " do
					net_http = ::Net::HTTP.new("broker.cloudmqtt.com",1883)
					net_http.should_receive(:request)
					http = ::Sensit::Messenger::HTTP.new(username: "user", password: "pass", host: "broker.cloudmqtt.com", port: 1883)
					Net::HTTP.should_receive(:start).with("broker.cloudmqtt.com", 1883, {:use_ssl=> false}).and_yield(net_http).and_return(Net::HTTPSuccess.new(1,200,""))
					http.publish("channel", {"some" => "data"})
				end
			end
		end
	end
end