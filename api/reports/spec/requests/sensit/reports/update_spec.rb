require 'spec_helper'
describe "PUT sensit/reports#update" do

	def url(report, format= "json")
		"/api/topics/#{report.topic.to_param}/reports/#{report.to_param}"
	end

	def process_oauth_request(access_grant,report, params, format= "json")
		oauth_put access_grant, url(report, format), valid_request(params), valid_session(:user_id => report.topic.user.to_param)
	end

	def process_request(report, params, format= "json")
		put url(report, format), valid_request(params), valid_session(:user_id => report.topic.user.to_param)
	end

	context "with valid attributes" do

		before(:each) do
			@params = {
				:report => {
					:name => "My New Report"
				}
			}
			# :facets => { "statistical" => { "field" => "num2"}}
		end

		context "oauth authentication" do
			context "with write access to the users data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_reports")
				end
				context "a report from the application and user" do
					before(:each) do
						@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
						@report = FactoryGirl.create(:report, :name => "My Report", :topic => @topic)
					end
					it "returns a 200 status code" do
						response = process_oauth_request(@access_grant,@report, @params)
						response.status.should == 200
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@report, @params)
						facet_arr = @report.facets.inject([]) do |facet_arr, facet|
							facet_arr << "{\"query\":#{facet.query.to_json}, \"name\":\"#{facet.name}\"}"
						end
						response.body.should be_json_eql("{\"name\": \"#{@params[:report][:name]}\",\"query\":{\"match_all\":{}},\"total\": 3,\"facets\": [{\"missing\": 0,\"name\": \"My Reportfacet\",\"query\": {\"terms\": {\"field\": \"value1\"}},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}]}")
					end
				end

				context "updating report from another application" do
					before(:each) do
						@application = FactoryGirl.create(:application)
						@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
						@report = FactoryGirl.create(:report, :name => "My Report", :topic => @topic)
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@report, @params)
						response.status.should == 200
						response.body.should be_json_eql("{\"name\": \"#{@params[:report][:name]}\",\"query\":{\"match_all\":{}},\"total\": 3,\"facets\": [{\"missing\": 0,\"name\": \"My Reportfacet\",\"query\": {\"terms\": {\"field\": \"value1\"}},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}]}")
					end
				end

				context "updating a report owned by another user" do
					before(:each) do
						another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
						topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
						@report = FactoryGirl.create(:report, :name => "My Report", :topic => @topic)
					end
					it "cannot read data from another user" do
						expect{
							response = process_oauth_request(@access_grant, @report, @params)
							response.status.should == 404
						}.to raise_error(ActiveRecord::RecordNotFound)
					end
				end
			end
			context "with write access to only the applications data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_application_reports")
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@report = FactoryGirl.create(:report, :name => "My Report", :topic => @topic)
				end
				it "cannot update data to another application" do
					expect{
						response = process_oauth_request(@access_grant, @report, @params)
						response.status.should == 401
					}.to raise_error(OAuth2::Error)
				end
			end				
		end
		context "no authentication" do
			before(:each) do
				@topic = FactoryGirl.create(:topic, user: @user, application: nil)
				@report = FactoryGirl.create(:report, :name => "My Report", :topic => @topic)
			end
			it "is unauthorized" do
				status = process_request(@report, @params)
				status.should == 401
			end
		end		
	end
end