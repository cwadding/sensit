require 'spec_helper'
describe "PUT sensit/subscriptions#update" do

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_subscriptions")
		topic = FactoryGirl.create(:topic, :user => @user, application: @access_grant.application)
		@subscription = FactoryGirl.create(:subscription, :topic => topic)
	end


	def process_oauth_request(access_grant,subscription, params)
		oauth_put access_grant, "/api/topics/#{subscription.topic.to_param}/subscriptions/#{subscription.to_param}", valid_request(params), valid_session(user_id: subscription.topic.user.to_param)
	end

	context "with correct attributes" do

		before(:each) do
			@params = {
				:subscription => {
					:name => "MyNewString",
					:host => "localhost"
				}
			}
		end
		it "returns a 200 status code" do
			response = process_oauth_request(@access_grant,@subscription, @params)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_oauth_request(@access_grant,@subscription, @params)
			response.body.should be_json_eql("{\"name\": \"MyNewString\",\"host\": \"localhost\"}")
		end
	end
end