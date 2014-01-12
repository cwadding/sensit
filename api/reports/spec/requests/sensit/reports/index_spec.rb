require 'spec_helper'
describe "GET sensit/reports#index" do

	def process_request(report, params = {})
		get "/api/topics/#{report.topic.to_param}/reports", valid_request(params), valid_session
	end


	context "with 1 report" do
		before(:each) do
			@report = FactoryGirl.create(:report, :name => "My Report", :topic => FactoryGirl.create(:topic_with_feeds))
		end
		it "is successful" do
			status = process_request(@report)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@report)
			# facet_arr = @report.facets.inject([]) do |facet_arr, facet|
			# 	facet_arr << "{\"query\":#{facet.query.to_json}, \"name\":\"#{facet.name}\"}"
			# end
			response.body.should be_json_eql("{\"reports\": [{\"name\":\"#{@report.name}\",\"query\":{\"match_all\":{}},\"total\":3,\"facets\":[{\"missing\": 0,\"name\": \"My Reportfacet\",\"query\": {\"terms\": {\"field\": \"value1\"}},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}	]}]}")
		end
	end


	context "with > 1 report" do
		before(:each) do
			topic = FactoryGirl.create(:topic_with_feeds)
			@reports = [FactoryGirl.create(:report, :name => "R1", :topic => topic), FactoryGirl.create(:report, :name => "R2", :topic => @topic), FactoryGirl.create(:report, :name => "R3", :topic => topic)]
		end

		it "returns the expected json" do
			report = @reports.last
			process_request(report, {page:2, per:1})
			# facet_arr = report.facets.inject([]) do |facet_arr, facet|
			# 	facet_arr << "{\"query\":#{facet.query.to_json}, \"name\":\"#{facet.name}\"}"
			# end
			response.body.should be_json_eql("{\"reports\": [{\"name\":\"R3\",\"query\":{\"match_all\":{}}, \"total\": 3,\"facets\":[{\"missing\": 0,\"name\": \"R3facet\",\"query\": {\"terms\": {\"field\": \"value1\"}},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}]}]}")
		end
	end
end
