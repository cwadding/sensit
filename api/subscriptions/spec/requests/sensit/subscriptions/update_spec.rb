require 'spec_helper'
describe "PUT sensit/subscriptions#update" do

		before(:each) do
			topic = FactoryGirl.create(:topic, :user => @user, application: @application)
			@subscription = FactoryGirl.create(:subscription, :topic => topic)
		end


	def process_request(subscription, params)
		put "/api/topics/#{subscription.topic.to_param}/subscriptions/#{subscription.to_param}", valid_request(params), valid_session(user_id: subscription.topic.user.to_param)
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
			status = process_request(@subscription, @params)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@subscription, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"name\": \"MyNewString\",\"host\": \"localhost\"}")
		end
	end
end