require 'spec_helper'
describe "POST sensit/subscriptions#create"  do

	def process_request(topic, params)
		oauth_post "/api/topics/#{topic.to_param}/subscriptions", valid_request(params), valid_session(user_id: topic.user.to_param)
	end

	context "with correct attributes" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, :user => @user, application: @application)
			@params = {
				:subscription => {
					:name => "MyString",
					:host => "127.0.0.1"
				}
			}
		end
		it "returns a 200 status code" do
			response = process_request(@topic, @params)
			response.status.should == 201
		end

		it "returns the expected json" do
			response = process_request(@topic, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"name\": \"#{@params[:subscription][:name]}\",\"host\": \"#{@params[:subscription][:host]}\"}")
		end
	end

	context "with incorrect attributes" do

	end
end