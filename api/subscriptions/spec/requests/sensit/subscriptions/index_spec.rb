require 'spec_helper'
describe "GET sensit/subscriptions#index" do

	def process_request
		get "/api/topics/1/subscriptions", valid_request, valid_session
	end


	context "with > 1 subscription" do
		before(:each) do
			@subscription = ::Sensit::Topic::Subscription.create({ :name => "MyString", :host => "127.0.0.1", :topic_id => 1})
		end
		it "is successful" do
			status = process_request
			status.should == 200
		end

		it "returns the expected json" do
			process_request
			response.body.should be_json_eql("{\"subscriptions\": [{\"id\":\"#{@subscription.id}\",\"name\": \"#{@subscription.name}\",\"host\": \"#{@subscription.host}\"}]}")
		end
	end
end
