require 'spec_helper'
describe "PUT sensit/subscriptions#update" do

	def url(subscription, format = "json")
		"/api/topics/#{subscription.topic.to_param}/subscriptions/#{subscription.to_param}"
	end

	def process_oauth_request(access_grant,subscription, params = {}, format = "json")
		oauth_put access_grant, url(subscription, format), valid_request(params), valid_session(user_id: subscription.topic.user.to_param)
	end

	def process_request(subscription, params, format = "json")
		put url(subscription, format), valid_request(params), valid_session(user_id: subscription.topic.user.to_param)
	end	

	context "with valid attributes" do

		before(:each) do
			@params = {
				:subscription => {
					:name => "MyNewString",
					:host => "localhost"
				}
			}
		end
		context "oauth authentication" do
			context "with write access to the users data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_subscriptions")
				end
				context "writing to own application" do
					before(:each) do
						topic = FactoryGirl.create(:topic, :user => @user, application: @access_grant.application)
						@subscription = FactoryGirl.create(:subscription, :topic => topic)
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
				context "updating subscription from another application" do
					before(:each) do
						@application = FactoryGirl.create(:application)
						topic = FactoryGirl.create(:topic, user: @user, application: @application)
						@subscription = FactoryGirl.create(:subscription, :topic => topic)
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@subscription, @params)
						response.status.should == 200
						response.body.should be_json_eql("{\"name\": \"MyNewString\",\"host\": \"localhost\"}")
					end
				end

				context "updating a subscription owned by another user" do
					before(:each) do
						another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
						topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
						@subscription = FactoryGirl.create(:subscription, :topic => topic)
					end
					it "cannot read data from another user" do
						expect{
							response = process_oauth_request(@access_grant, @subscription, @params)
							response.status.should == 404
						}.to raise_error(ActiveRecord::RecordNotFound)
					end
				end				
			end
			context "with write access to only the applications data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_application_subscriptions")
					@application = FactoryGirl.create(:application)
					topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@subscription = FactoryGirl.create(:subscription, :topic => topic)
				end
				it "cannot update data to another application" do
					expect{
						response = process_oauth_request(@access_grant, @subscription, @params)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end				
		end
		context "no authentication" do
			before(:each) do
				@topic = FactoryGirl.create(:topic, user: @user, application: nil)
				@subscription = FactoryGirl.create(:subscription, :topic => @topic)
			end
			it "is unauthorized" do
				status = process_request(@subscription, @params)
				status.should == 401
			end
		end			
	end
end