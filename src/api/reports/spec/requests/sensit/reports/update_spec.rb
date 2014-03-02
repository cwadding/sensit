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
					:name => "My New Report",
				}
			}
			# :facets => { "statistical" => { "field" => "num2"}}
		end

		context "oauth authentication" do
			context "with write access to the users data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_reports")
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
						# aggregation_arr = @report.aggregations.inject([]) do |aggregation_arr, aggregation|
						# 	aggregation_arr << "{\"query\":#{aggregation.query.to_json},\"type\":\"terms\" \"name\":\"#{aggreagtion.name}\"}"
						# end
						response.body.should be_json_eql("{\"name\": \"#{@params[:report][:name]}\",\"query\":{\"match_all\":{}},\"aggregations\":[{\"name\": \"My Reportaggregation\",\"type\":\"terms\", \"query\": {\"field\": \"value1\"},\"results\": {\"buckets\": [{\"doc_count\": 1, \"key\": 0}, {\"doc_count\": 1, \"key\": 1}, {\"doc_count\": 1,\"key\": 2  }]}}], \"total\":3}")
					end
				end

				context "updating report from another application" do
					before(:each) do
						@application = FactoryGirl.create(:application)
						topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
						@report = FactoryGirl.create(:report, :name => "My Report", :topic => topic)
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@report, @params)
						response.status.should == 200
						response.body.should be_json_eql("{\"name\": \"#{@params[:report][:name]}\",\"query\":{\"match_all\":{}},\"aggregations\":[{\"name\": \"My Reportaggregation\",\"type\":\"terms\", \"query\": {\"field\": \"value1\"},\"results\": {\"buckets\": [{\"doc_count\": 1, \"key\": 0}, {\"doc_count\": 1, \"key\": 1}, {\"doc_count\": 1,\"key\": 2  }]}}], \"total\":3}")						
					end
				end

				context "updating a report owned by another user" do
					before(:each) do
						@client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
						another_user = Sensit::User.create(:name => "another_user", :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
						topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
						@report = FactoryGirl.create(:report, :name => "My Report", :topic => topic)
					end
					after(:each) do
						@client.indices.flush(index: "another_user", refresh: true)
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
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_reports")
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@report = FactoryGirl.create(:report, :name => "My Report", :topic => @topic)
				end
				it "cannot update data to another application" do
					expect{
						response = process_oauth_request(@access_grant, @report, @params)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
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