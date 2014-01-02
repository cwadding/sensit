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
			response.body.should be_json_eql("{\"reports\": [{\"name\":\"#{@report.name}\",\"query\":#{@report.query.to_json}}]}")
		end
	end

	context "with > 1 report" do
		before(:each) do
			@reports = [FactoryGirl.create(:report, :name => "R1"), FactoryGirl.create(:report, :name => "R2"), FactoryGirl.create(:report, :name => "R3")]
		end

		it "returns the expected json" do
			process_request(@reports.first, {offset:2, limit:1})
			puts response.body.inspect
			response.body.should be_json_eql("{\"reports\": [{\"name\":\"#{@report.name}\",\"query\":#{@report.query.to_json}}]}")
		end
	end
end
