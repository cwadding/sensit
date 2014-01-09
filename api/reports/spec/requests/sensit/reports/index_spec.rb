require 'spec_helper'
describe "GET sensit/reports#index" do

	def process_request(report, params = {})
		get "/api/topics/#{report.topic.to_param}/reports", valid_request(params), valid_session
	end


	context "with 1 report" do
		before(:each) do
			@report = FactoryGirl.create(:report)
		end
		it "is successful" do
			status = process_request(@report)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@report)
			facet_arr = @report.facets.inject([]) do |facet_arr, facet|
				facet_arr << "{\"body\":#{facet.body.to_json}, \"name\":\"#{facet.name}\"}"
			end
			response.body.should be_json_eql("{\"reports\": [{\"name\":\"#{@report.name}\",\"query\":{\"match_all\":{}},\"facets\":[#{facet_arr.join(',')}]}]}")
		end
	end

	context "with > 1 report" do
		before(:each) do
			@topic = FactoryGirl.create(:topic)
			@reports = [FactoryGirl.create(:report, :name => "R1", :topic => @topic), FactoryGirl.create(:report, :name => "R2", :topic => @topic), FactoryGirl.create(:report, :name => "R3", :topic => @topic)]
		end

		it "returns the expected json" do
			report = @reports.last
			process_request(report, {page:2, per:1})
			facet_arr = report.facets.inject([]) do |facet_arr, facet|
				facet_arr << "{\"body\":#{facet.body.to_json}, \"name\":\"#{facet.name}\"}"
			end
			response.body.should be_json_eql("{\"reports\": [{\"name\":\"R2\",\"query\":{\"match_all\":{}},\"facets\":[#{facet_arr.join(',')}]}]}")
		end
	end
end
