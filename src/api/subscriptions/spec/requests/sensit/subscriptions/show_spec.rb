require 'spec_helper'
describe "GET sensit/subscriptions#show" do

	def url(subscription, format="json")
		"/api/topics/#{subscription.topic.to_param}/subscriptions/#{subscription.to_param}.#{format}"
	end

	def process_oauth_request(access_grant,subscription, format="json")
		oauth_get access_grant, url(subscription, format), valid_request(format: format), valid_session(user_id: subscription.topic.user.to_param)
	end

	def process_request(subscription, format="json")
		get url(subscription, format), valid_request(format: format), valid_session(user_id: subscription.topic.user.to_param)
	end

	context "oauth authentication" do
		context "with read access to the users percolator data" do

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
					response.body.should be_json_eql("{\"name\": \"#{@subscription.name}\",\"host\": \"#{@subscription.host}\",\"protocol\": \"#{@subscription.protocol}\"}")
				end

			end

			context "when the subscription does not exist" do
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
			context "reading report from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@subscription = FactoryGirl.create(:subscription, :topic => topic)
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@subscription)
					response.status.should == 200
					response.body.should be_json_eql("{\"name\": \"#{@subscription.name}\",\"host\": \"#{@subscription.host}\",\"protocol\": \"#{@subscription.protocol}\"}")
				end
			end

			context "reading a report owned by another user" do
				before(:each) do
					another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
					@subscription = FactoryGirl.create(:subscription, :topic => topic)
				end
				it "cannot read data from another user" do
					expect{
						response = process_oauth_request(@access_grant, @subscription)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end				
		end
		context "with read access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_application_subscriptions")
				@application = FactoryGirl.create(:application)
				topic = FactoryGirl.create(:topic, user: @user, application: @application)
				@subscription = FactoryGirl.create(:subscription, :topic => topic)
			end
			it "cannot read data to another application" do
				expect{
					response = process_oauth_request(@access_grant, @subscription)
					response.status.should == 404
				}.to raise_error(ActiveRecord::RecordNotFound)
			end
		end			
	end

	context "no authentication" do
		before(:each) do
			topic = FactoryGirl.create(:topic, user: @user, application: nil)
			@subscription = FactoryGirl.create(:subscription, :topic => topic)
		end
		it "is unauthorized" do
			status = process_request(@subscription)
			status.should == 401
		end
	end		
end