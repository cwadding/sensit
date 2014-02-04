require 'spec_helper'
describe "DELETE sensit/subscriptions#destroy" do

	def url(subscription, format = "json")
		"/api/topics/#{subscription.topic.to_param}/subscriptions/#{subscription.to_param}.#{format}"
	end

	def process_oauth_request(access_grant,subscription, format = "json")
		oauth_delete access_grant, url(subscription, format), valid_request, valid_session(user_id: subscription.topic.user.to_param)
	end

	def process_request(subscription, format = "json")
		delete url(subscription, format), valid_request, valid_session(user_id: subscription.topic.user.to_param)
	end	

	context "oauth authentication" do
		context "with delete access to the users percolator data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_subscriptions")
			end

			context "when the subscription exists" do
				before(:each) do
					topic = FactoryGirl.create(:topic, :user => @user, application: @access_grant.application)
					@subscription = FactoryGirl.create(:subscription, :topic => topic)
				end
				it "is successful" do
					response = process_oauth_request(@access_grant,@subscription)
					response.status.should == 204
				end

				it "deletes the Subscription" do
					expect {
						response = process_oauth_request(@access_grant,@subscription)
					}.to change(Sensit::Topic::Subscription, :count).by(-1)
		        end
			end
			context "when the subscription does not exist" do
				it "is unsuccessful" do
					expect{
						response = oauth_delete @access_grant, "/api/topics/1/subscriptions/1", valid_request, valid_session(user_id: @user.to_param)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end
			context "deleting subscription from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@subscription = FactoryGirl.create(:subscription, :topic => topic)
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@subscription)
					response.status.should == 204
				end
			end

			context "deleting a subscription owned by another user" do
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

		context "with delete access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_subscriptions")
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