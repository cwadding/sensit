require 'spec_helper'
describe "GET sensit/subscriptions#show" do

	def process_request(subscription)
		get "/api/topics/#{subscription.topic.to_param}/subscriptions/#{subscription.to_param}", valid_request, valid_session(user_id: subscription.topic.user.to_param)
	end


	context "when the subscription exists" do
		before(:each) do
			topic = FactoryGirl.create(:topic, :user => @user)
			@subscription = FactoryGirl.create(:subscription, :topic => topic)
		end

		it "is successful" do
			status = process_request(@subscription)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@subscription)
			response.body.should be_json_eql("{\"name\": \"#{@subscription.name}\",\"host\": \"#{@subscription.host}\"}")
		end

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
			status = get "/api/topics/1/subscriptions/1", valid_request, valid_session(user_id:@user.to_param)
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 404
		end

		it "returns the expected json" do
			expect{
				get "/api/topics/1/subscriptions/1", valid_request, valid_session(user_id:@user.to_param)
			}.to raise_error(ActiveRecord::RecordNotFound)
			#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end
end