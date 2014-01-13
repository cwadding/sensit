require 'spec_helper'
describe "GET sensit/subscriptions#index" do

	def process_request(topic)
		get "/api/topics/#{topic.to_param}/subscriptions", valid_request, valid_session(user_id: topic.user.to_param)
	end


	context "with > 1 subscription" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, :user => @user)
			@subscription = FactoryGirl.create(:subscription, :topic => topic)
		end
		it "is successful" do
			status = process_request(@topic)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@topic)
			response.body.should be_json_eql("{\"subscriptions\": [{\"name\": \"#{@subscription.name}\",\"host\": \"#{@subscription.host}\"}]}")
		end
	end
end
