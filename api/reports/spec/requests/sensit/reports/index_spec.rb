require 'spec_helper'
describe "GET sensit/reports#index" do

	def process_oauth_request(access_grant,report, params = {})
		oauth_get access_grant, "/api/topics/#{report.topic.to_param}/reports", valid_request(params), valid_session(:user_id => report.topic.user.to_param)
	end

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_reports")
	end

	context "with 1 report" do
		before(:each) do
			@report = FactoryGirl.create(:report, :name => "My Report", :topic => FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application))
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
			response.body.should be_json_eql("{\"reports\": [{\"name\":\"#{@report.name}\",\"query\":{\"match_all\":{}},\"total\":3,\"facets\":[{\"missing\": 0,\"name\": \"My Reportfacet\",\"query\": {\"terms\": {\"field\": \"value1\"}},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}	]}]}")
		end
	end


	context "with > 1 report" do
		before(:each) do
			topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
			@reports = [FactoryGirl.create(:report, :name => "R1", :topic => topic), FactoryGirl.create(:report, :name => "R2", :topic => topic), FactoryGirl.create(:report, :name => "R3", :topic => topic)]
		end

		it "returns the expected json" do
			report = @reports.last
			response = process_oauth_request(@access_grant,report, {page:3, per:1})
			# facet_arr = report.facets.inject([]) do |facet_arr, facet|
			# 	facet_arr << "{\"query\":#{facet.query.to_json}, \"name\":\"#{facet.name}\"}"
			# end
			response.body.should be_json_eql("{\"reports\": [{\"name\":\"R3\",\"query\":{\"match_all\":{}}, \"total\": 3,\"facets\":[{\"missing\": 0,\"name\": \"R3facet\",\"query\": {\"terms\": {\"field\": \"value1\"}},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}]}]}")
		end
	end
end
