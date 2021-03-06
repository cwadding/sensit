require 'spec_helper'
describe "GET sensit/reports#show" do

	def url(report, format = "json")
		"/api/topics/#{report.topic.to_param}/reports/#{report.to_param}.#{format}"
	end

	def process_request(report, format = "json")
		get url(report, format), valid_request, valid_session(:user_id => report.topic.user.to_param)
	end

	def process_oauth_request(access_grant,report, format = "json")
		oauth_get access_grant, url(report, format), valid_request, valid_session(:user_id => report.topic.user.to_param)
	end
	context "oauth authentication" do
		context "with read access to the users percolator data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_reports")
			end
			context "when the report exists" do
				before(:each) do
					topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)					
					@report = FactoryGirl.create(:report, :name => "MyReport-1", :topic => topic)
				end

				it "is successful" do
					response = process_oauth_request(@access_grant,@report)
					response.status.should == 200
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@report)
					response.body.should be_json_eql("{\"name\":\"#{@report.name}\",\"query\":{\"match_all\":{}},\"aggregations\":[{\"name\": \"#{@report.name}aggregation\",\"type\":\"terms\", \"query\": {\"field\": \"value1\"},\"results\": {\"buckets\": [{\"doc_count\": 1, \"key\": 0}, {\"doc_count\": 1, \"key\": 1}, {\"doc_count\": 1,\"key\": 2  }]}}], \"total\":3}")
				end
			end

			context "when the report does not exist" do
				it "is unsuccessful" do
					expect{
						response = oauth_get @access_grant, "/api/topics/1/reports/1", valid_request, valid_session(:user_id => @user.to_param)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
					
				end

				it "returns the expected json" do
					expect{
						response = oauth_get @access_grant, "/api/topics/1/reports/1", valid_request, valid_session(:user_id => @user.to_param)
						response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
					}.to raise_error(ActiveRecord::RecordNotFound)
					
				end
			end

			context "reading report from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
					@report = FactoryGirl.create(:report, :name => "MyReport-1", :topic => topic)
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@report)
					response.status.should == 200
					response.body.should be_json_eql("{\"name\":\"#{@report.name}\",\"query\":{\"match_all\":{}},\"aggregations\":[{\"name\": \"#{@report.name}aggregation\",\"type\":\"terms\", \"query\": {\"field\": \"value1\"},\"results\": {\"buckets\": [{\"doc_count\": 1, \"key\": 0}, {\"doc_count\": 1, \"key\": 1}, {\"doc_count\": 1,\"key\": 2  }]}}], \"total\":3}")
				end
			end

			context "reading a report owned by another user" do
				before(:each) do
					@client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
					another_user = Sensit::User.create(:name => "another_user", :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
					@report = FactoryGirl.create(:report, :name => "MyReport-1", :topic => topic)
				end
				after(:each) do
					@client.indices.flush(index: "another_user", refresh: true)
				end					
				it "cannot read data from another user" do
					expect{
						response = process_oauth_request(@access_grant, @report)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end			
		end
		context "with read access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_application_reports")
				@application = FactoryGirl.create(:application)
				topic = FactoryGirl.create(:topic, user: @user, application: @application)
				@report = FactoryGirl.create(:report, :name => "MyReport-1", :topic => topic)
			end
			it "cannot read data to another application" do
				expect{
					response = process_oauth_request(@access_grant, @report)
					response.status.should == 404
				}.to raise_error(ActiveRecord::RecordNotFound)
			end
		end		
	end

	context "no authentication" do
		before(:each) do
			topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: nil)
			@report = FactoryGirl.create(:report, :name => "MyReport-1", :topic => topic)
		end
		it "is unauthorized" do
			status = process_request(@report)
			status.should == 401
		end
	end	

end