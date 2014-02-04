require 'spec_helper'
describe "POST sensit/reports#create"  do

	def url(topic, format = "json")
		"/api/topics/#{topic.to_param}/reports.#{format}"
	end

	def process_oauth_request(access_grant,topic, params, format = "json")
		oauth_post access_grant, url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	def process_request(topic, params, format = "json")
		post url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end	

	context "with valid attributes" do

		context "with facets" do 
			before(:each) do
				@params = {
					:report => {
						:name => "My Report",
						:facets => [{"name" => "facet1", "type" => "terms", "query" => { :field => "value1"}}]
					}
				}
			end
			context "oauth authentication" do
				context "with write access to the users data" do
					before(:each) do
						@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_reports")
					end
					context "creating reports for the current application and user" do
						before(:each) do
							@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
						end
						it "returns a 200 status code" do
							response = process_oauth_request(@access_grant,@topic, @params)
							response.status.should == 201
						end

						it "returns the expected json" do
							response = process_oauth_request(@access_grant,@topic, @params)
							response.body.should be_json_eql("{\"name\": \"#{@params[:report][:name]}\",\"query\":{\"match_all\":{}},\"facets\":[{\"missing\": 0,\"name\": \"facet1\",\"type\":\"terms\", \"query\": {\"field\": \"value1\"},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}], \"total\":3}")
						end
					end
					context "creating report for another application" do
						before(:each) do
							@application = FactoryGirl.create(:application)
							@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
						end

						it "returns the expected json" do
							response = process_oauth_request(@access_grant,@topic, @params)
							response.status.should == 201
							response.body.should be_json_eql("{\"name\": \"#{@params[:report][:name]}\",\"query\":{\"match_all\":{}},\"facets\":[{\"missing\": 0,\"name\": \"facet1\",\"type\":\"terms\",\"query\": {\"field\": \"value1\"},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}], \"total\":3}")
						end
					end


					context "creating a report owned by another user" do
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
						@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_reports")
						@application = FactoryGirl.create(:application)
						@topic = FactoryGirl.create(:topic, user: @user, application: @application)
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
		context "without facets" do
			#{@params[:report][:facets].to_json		
		end
	end
	context "with incorrect attributes" do

	end	

end