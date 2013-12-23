require 'spec_helper'
describe "GET sensit/reports#index" do

	def process_request(report)
		get "/api/topics/#{report.topic.to_param}/reports", valid_request, valid_session
	end


	context "with > 1 report" do
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
end
