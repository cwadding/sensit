require 'spec_helper'
describe "POST sensit/subscriptions#create"  do

	def url(topic, format="json")
		"/api/topics/#{topic.to_param}/subscriptions.#{format}"
	end

	def process_oauth_request(access_grant,topic, params, format="json")
		oauth_post access_grant, url(topic, format), valid_request(params), valid_session(user_id: topic.user.to_param)
	end

	def process_request(topic, params, format="json")
		post url(topic, format), valid_request(params), valid_session(user_id: topic.user.to_param)
	end	

	context "with correct attributes" do
		before(:each) do
			@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_subscriptions")
			@topic = FactoryGirl.create(:topic, :user => @user, application: @access_grant.application)
			@params = {
				:subscription => {
					:name => "MyString",
					:host => "127.0.0.1"
				}
			}
		end
		it "returns a 200 status code" do
			response = process_oauth_request(@access_grant,@topic, @params)
			response.status.should == 201
		end

		it "returns the expected json" do
			response = process_oauth_request(@access_grant,@topic, @params)
			response.body.should be_json_eql("{\"name\": \"#{@params[:subscription][:name]}\",\"host\": \"#{@params[:subscription][:host]}\"}")
		end
	end

	context "with incorrect attributes" do

	end
end