require 'spec_helper'
describe "DELETE sensit/percolators#destroy" do

	def process_request(percolator)
		delete "/api/topics/#{percolator.type}/percolators/#{percolator.id}", valid_request, valid_session
	end

	context "when the percolator exists" do
		before(:each) do
          @percolator = ::Sensit::Topic::Percolator.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "3", body: { query: { query_string: { query: 'foo' } } } })
		end
		it "is successful" do
			status = process_request(@percolator)
			status.should == 204
		end

		it "deletes the Percolator" do
			client = ::Elasticsearch::Client.new
			expect {
				process_request(@percolator)
				client.indices.refresh(:index => ELASTIC_SEARCH_INDEX_NAME)
			}.to change(Sensit::Topic::Percolator, :count).by(-1)
        end

 #        it "removes that feed from the elastic_search index"

	end

	context "when the percolator does not exist" do
		it "is unsuccessful" do
			expect{
				status = delete "/api/topics/1/percolators/1", valid_request, valid_session
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#status.should == 404
		end
	end	
end