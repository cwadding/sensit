require 'spec_helper'
describe "GET sensit/subscriptions#show" do

	def process_request(subscription)
		get "/api/topics/#{subscription.type}/subscriptions/#{subscription.id}", valid_request, valid_session
	end


	context "when the subscription exists" do
		before(:each) do
			@subscription = ::Sensit::Topic::Percolator.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "3", body: { query: { query_string: { query: 'foo' } } } })
		end

		it "is successful" do
			status = process_request(@subscription)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@subscription)
			response.body.should be_json_eql("{\"id\":\"#{@subscription.id}\",\"body\":\"#{@subscription.body.to_json}\"}")
		end

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
			status = get "/api/topics/1/subscriptions/1", valid_request, valid_session
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#status.should == 404
		end

		it "returns the expected json" do
			expect{
				get "/api/topics/1/subscriptions/1", valid_request, valid_session
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end
end