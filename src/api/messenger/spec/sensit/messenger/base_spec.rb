require 'spec_helper'

module Sensit
	module Messenger
		describe Base do
			describe "#uri=" do
				it "parses the uri and assigns the attributes" do
					base = ::Sensit::Messenger::Base.new
					base.uri = "http://user:pass@broker.cloudmqtt.com:1883"
					base.username.should == "user"
					base.password.should == "pass"
					base.host.should == "broker.cloudmqtt.com"
					base.port.should == 1883
				end
			end
			describe "#uri" do
				it "returns the uri as a string" do
					base = ::Sensit::Messenger::Base.new(username: "user", password: "pass", host: "broker.cloudmqtt.com", port: 1883)
					base.uri.should == "http://user:pass@broker.cloudmqtt.com:1883"
				end
			end	
		end
	end
end