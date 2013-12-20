require 'spec_helper'
describe "GET sensit/subscriptions#index" do

	def process_request
		get "/api/topics/#{ELASTIC_SEARCH_INDEX_TYPE}/subscriptions", valid_request, valid_session
	end


	context "with > 1 subscription" do
		before(:each) do
			@subscription = ::Sensit::Topic::Percolator.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "3", body: { query: { query_string: { query: 'foo' } } } })
		end
		it "is successful" do
			status = process_request
			status.should == 200
		end

		it "returns the expected json" do
			process_request
			response.body.should be_json_eql("{\"subscriptions\": [{\"id\":\"#{@subscription.id}\",\"body\":\"#{@subscription.body.to_json}\"}]}")
		end
	end
end
