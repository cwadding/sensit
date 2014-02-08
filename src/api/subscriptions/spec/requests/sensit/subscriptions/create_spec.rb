require 'spec_helper'
describe "POST sensit/subscriptions#create"  do

	def url(format="json")
		"/api/subscriptions.#{format}"
	end

	def process_oauth_request(access_grant,params, format="json")
		oauth_post access_grant, url(format), valid_request(params), valid_session
	end

	def process_request(params, format="json")
		post url(format), valid_request(params), valid_session
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
					it "returns a 200 status code" do
						response = process_oauth_request(@access_grant, @params)
						response.status.should == 201
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant, @params)
						response.body.should be_json_eql("{\"name\": \"#{@params[:subscription][:name]}\",\"host\": \"broker.cloudmqtt.com\",\"protocol\": \"mqtt\", \"username\": \"user\",\"password\": \"pass\",\"port\":1883 }")
					end
				end

				context "creating subscription for another application" do
					before(:each) do
						@application = FactoryGirl.create(:application)
						@params.merge!(application_id:@application.id)
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant, @params)
						response.status.should == 201
						response.body.should be_json_eql("{\"name\": \"#{@params[:subscription][:name]}\",\"host\": \"broker.cloudmqtt.com\",\"protocol\": \"mqtt\", \"username\": \"user\",\"password\": \"pass\",\"port\":1883 }")
					end
				end
			end
			context "with write access to only the applications data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_subscriptions")
					@application = FactoryGirl.create(:application)
					@params.merge!({:application_id =>  @application.to_param})
				end
				it "cannot update data to another application" do
					expect{
						response = process_oauth_request(@access_grant, @params)
						response.status.should == 401
					}.to raise_error(OAuth2::Error)
				end
			end				
		end
		context "no authentication" do
			it "is unauthorized" do
				status = process_request(@params)
				status.should == 401
			end
		end			
	end

	context "with invalid attributes" do

	end
end