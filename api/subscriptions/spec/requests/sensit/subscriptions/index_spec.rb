require 'spec_helper'
describe "GET sensit/subscriptions#index" do

	def process_request(subscription)
		get "/api/topics/#{subscription.topic.to_param}/subscriptions", valid_request, valid_session
	end


	context "with > 1 subscription" do
		before(:each) do
			@subscription = FactoryGirl.create(:subscription)
		end
		it "is successful" do
			status = process_request(@subscription)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@subscription)
			response.body.should be_json_eql("{\"subscriptions\": [{\"name\": \"#{@subscription.name}\",\"host\": \"#{@subscription.host}\"}]}")
		end
	end
end
