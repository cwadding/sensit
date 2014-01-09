require 'spec_helper'
describe "GET sensit/percolators#index" do

	def process_request
		get "/api/topics/#{ELASTIC_SEARCH_INDEX_TYPE}/percolators", valid_request, valid_session
	end


	context "with > 1 percolator" do
		it "is successful" do
			percolator = ::Sensit::Topic::Percolator.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "10", body: { query: { query_string: { query: 'foo' } } } })
			status = process_request
			status.should == 200
		end

		it "returns the expected json" do
			percolator = ::Sensit::Topic::Percolator.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "11", body: { query: { query_string: { query: 'foo' } } } })
			process_request
			response.body.should be_json_eql("{\"percolators\": [{\"id\":\"#{percolator.id}\",\"body\":#{percolator.body.to_json}}]}")
		end
	end

	context "pagination" do
	end

end
