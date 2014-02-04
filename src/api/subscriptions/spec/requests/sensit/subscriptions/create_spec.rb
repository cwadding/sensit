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

	context "with valid attributes" do
		before(:each) do
			@params = {
				:subscription => {
					:name => "MyString",
					:uri => "mqtt://user:pass@broker.cloudmqtt.com:1883"
				}
			}
		end

		context "oauth authentication" do
			context "with write access to the users data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_subscriptions")
				end
				context "creating subscriptions for the current application and user" do
					before(:each) do
						@topic = FactoryGirl.create(:topic, :user => @user, application: @access_grant.application)
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

				context "creating subscription for another application" do
					before(:each) do
						@application = FactoryGirl.create(:application)
						@topic = FactoryGirl.create(:topic, user: @user, application: @application)
					end

					it "returns the expected json", current:true do
						response = process_oauth_request(@access_grant,@topic, @params)
						response.status.should == 201
						response.body.should be_json_eql("{\"name\": \"#{@params[:subscription][:name]}\",\"host\": \"#{@params[:subscription][:host]}\"}")
					end
				end


				context "creating a subscription owned by another user" do
					before(:each) do
						another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
						@topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
					end
					it "cannot read data from another user" do
						expect{
							response = process_oauth_request(@access_grant, @topic, @params)
							response.status.should == 401
						}.to raise_error(OAuth2::Error)
					end
				end				
			end
			context "with write access to only the applications data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_subscriptions")
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@params.merge!({:application_id =>  @application.to_param})
				end
				it "cannot update data to another application" do
					expect{
						response = process_oauth_request(@access_grant, @topic, @params)
						response.status.should == 401
					}.to raise_error(OAuth2::Error)
				end
			end				
		end
		context "no authentication" do
			before(:each) do
				@topic = FactoryGirl.create(:topic, user: @user, application: nil)
			end
			it "is unauthorized" do
				status = process_request(@topic, @params)
				status.should == 401
			end
		end			
	end

	context "with invalid attributes" do

	end
end