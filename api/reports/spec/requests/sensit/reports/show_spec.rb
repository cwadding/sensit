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

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_reports")
	end
	context "when the report exists" do
		before(:each) do
			@report = FactoryGirl.create(:report, :name => "MyReport-1", :topic => FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application))
		end

		it "is successful" do
			response = process_oauth_request(@access_grant,@report)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_oauth_request(@access_grant,@report)
			# facet_arr = @report.facets.inject([]) do |facet_arr, facet|
			# 	facet_arr << "{\"query\":#{facet.query.to_json}, \"name\":\"#{facet.name}\"}"
			# end
			response.body.should be_json_eql("{\"name\":\"#{@report.name}\",\"query\":{\"match_all\":{}},\"total\": 3,\"facets\":[{\"missing\": 0,\"name\": \"#{@report.name}facet\",\"query\": {\"terms\": {\"field\": \"value1\"}},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}]}")
		end
	end

	context "when the field does not exist" do
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
end