require 'spec_helper'

module Sensit
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
