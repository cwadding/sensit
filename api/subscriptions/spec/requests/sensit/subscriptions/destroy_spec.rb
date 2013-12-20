require 'spec_helper'
describe "DELETE sensit/subscriptions#destroy" do

	def process_request(subscription)
		delete "/api/topics/#{subscription.type}/subscriptions/#{subscription.id}", valid_request, valid_session
	end

	context "when the subscription exists" do
		before(:each) do
          @subscription = ::Sensit::Topic::Percolator.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "3", body: { query: { query_string: { query: 'foo' } } } })
		end
		it "is successful" do
			status = process_request(@subscription)
			status.should == 204
		end

		it "deletes the Percolator" do
			client = ::Elasticsearch::Client.new
			expect {
				process_request(@subscription)
				client.indices.refresh(:index => ELASTIC_SEARCH_INDEX_NAME)
			}.to change(Sensit::Topic::Percolator, :count).by(-1)
        end

 #        it "removes that feed from the elastic_search index"

	end

	context "when the subscription does not exist" do
		it "is unsuccessful" do
			expect{
				status = delete "/api/topics/1/subscriptions/1", valid_request, valid_session
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#status.should == 404
		end
	end	
end