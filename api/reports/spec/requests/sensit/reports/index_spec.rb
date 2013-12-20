require 'spec_helper'
describe "GET sensit/reports#index" do

	def process_request
		get "/api/topics/#{ELASTIC_SEARCH_INDEX_TYPE}/reports", valid_request, valid_session
	end


	context "with > 1 report" do
		before(:each) do
			@report = ::Sensit::Topic::Report.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "3", body: { query: { query_string: { query: 'foo' } } } })
		end
		it "is successful" do
			status = process_request
			status.should == 200
		end

		it "returns the expected json" do
			process_request
			response.body.should be_json_eql("{\"reports\": [{\"id\":\"#{@report.id}\",\"body\":\"#{@report.body.to_json}\"}]}")
		end
	end
end
