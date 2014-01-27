require 'spec_helper'
describe "GET sensit/subscriptions#show" do

	def process_oauth_request(access_grant,subscription)
		oauth_get access_grant, "/api/topics/#{subscription.topic.to_param}/subscriptions/#{subscription.to_param}", valid_request, valid_session(user_id: subscription.topic.user.to_param)
	end


	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_subscriptions")
	end
	context "when the subscription exists" do
		before(:each) do
			topic = FactoryGirl.create(:topic, :user => @user, application: @access_grant.application)
			@subscription = FactoryGirl.create(:subscription, :topic => topic)
		end

		it "is successful" do
			response = process_oauth_request(@access_grant,@subscription)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_oauth_request(@access_grant,@subscription)
			response.body.should be_json_eql("{\"name\": \"#{@subscription.name}\",\"host\": \"#{@subscription.host}\"}")
		end

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
				response = oauth_get @access_grant, "/api/topics/1/subscriptions/1", valid_request, valid_session(user_id:@user.to_param)
				response.status.should == 404
			}.to raise_error(ActiveRecord::RecordNotFound)
		end

		it "returns the expected json" do
			expect{
				response = oauth_get @access_grant, "/api/topics/1/subscriptions/1", valid_request, valid_session(user_id:@user.to_param)
				response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
			}.to raise_error(ActiveRecord::RecordNotFound)
			
		end
	end
end