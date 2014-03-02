require 'spec_helper'
describe "GET sensit/reports#index" do

	def url(topic, format = "json")
		"/api/topics/#{topic.to_param}/reports.#{format}"
	end

	def process_oauth_request(access_grant,topic, params = {}, format = "json")
		oauth_get access_grant, url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	def process_request(topic, params = {}, format = "json")
		get url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end	


	context "oauth authentication" do
		context "with write access to the users percolator data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_reports")
			end

			context "with no reports" do
				before(:each) do
					@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
				end
				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					response.body.should be_json_eql("{\"reports\": []}")
				end
			end
			context "with 1 report" do
				before(:each) do
					@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
					@report = FactoryGirl.create(:report, :name => "My Report", :topic => @topic)
				end
				it "is successful" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					response.body.should be_json_eql("{\"reports\": [{\"name\":\"#{@report.name}\",\"query\":{\"match_all\":{}},\"aggregations\":[{\"name\": \"My Reportaggregation\",\"type\":\"terms\", \"query\": {\"field\": \"value1\"},\"results\": {\"buckets\": [{\"doc_count\": 1, \"key\": 0}, {\"doc_count\": 1, \"key\": 1}, {\"doc_count\": 1,\"key\": 2  }]}}], \"total\":3}]}")
				end
			end
			context "with > 1 report" do
				before(:each) do
					@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
					@reports = [
						FactoryGirl.create(:report, :name => "R1", :topic => @topic), 
						FactoryGirl.create(:report, :name => "R2", :topic => @topic), 
						FactoryGirl.create(:report, :name => "R3", :topic => @topic)
					]
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic, {page:3, per:1})
					response.body.should be_json_eql("{\"reports\": [{\"name\":\"R3\",\"query\":{\"match_all\":{}},\"aggregations\":[{\"name\": \"R3aggregation\",\"type\":\"terms\", \"query\": {\"field\": \"value1\"},\"results\": {\"buckets\": [{\"doc_count\": 1, \"key\": 0}, {\"doc_count\": 1, \"key\": 1}, {\"doc_count\": 1,\"key\": 2  }]}}], \"total\":3}]}")
				end
			end

			context "reading reports from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
					@report = FactoryGirl.create(:report, :name => "My Report", :topic => @topic)
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
					response.body.should be_json_eql("{\"reports\": [{\"name\":\"#{@report.name}\",\"query\":{\"match_all\":{}},\"aggregations\":[{\"name\": \"My Reportaggregation\",\"type\":\"terms\", \"query\": {\"field\": \"value1\"},\"results\": {\"buckets\": [{\"doc_count\": 1, \"key\": 0}, {\"doc_count\": 1, \"key\": 1}, {\"doc_count\": 1,\"key\": 2  }]}}], \"total\":3}]}")
				end
			end

			context "with a report owned by another user" do
				before(:each) do
					@client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
					another_user = Sensit::User.create(:name => "another_user", :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					@topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
					@report = FactoryGirl.create(:report, :name => "My Report", :topic => @topic)
				end
				after(:each) do
					@client.indices.flush(index: "another_user", refresh: true)
				end					
				it "cannot read data from another user" do
					response = process_oauth_request(@access_grant, @topic)
					response.body.should be_json_eql("{\"reports\": []}")
				end
			end		
		end
		context "with read access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_application_reports")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic, user: @user, application: @application)
				report = FactoryGirl.create(:report, :name => "My Report", :topic => @topic)
			end
			it "cannot read data of other application" do
				response = process_oauth_request(@access_grant, @topic)
				response.body.should be_json_eql("{\"reports\":[]}")
			end
		end
	end

	context "no authentication" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, user: @user, application: nil)
		end
		it "is unauthorized" do
			status = process_request(@topic)
			status.should == 401
		end
	end		
end
