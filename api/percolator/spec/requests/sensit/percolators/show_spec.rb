require 'spec_helper'
describe "GET sensit/percolators#show" do

	def process_request(percolator)
		get "/api/topics/#{percolator.type}/percolators/#{percolator.id}", valid_request, valid_session
	end


	context "when the percolator exists" do
		before(:each) do
			@percolator = ::Sensit::Topic::Percolator.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "3", body: { query: { query_string: { query: 'foo' } } } })
		end

		it "is successful" do
			status = process_request(@percolator)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@percolator)
			response.body.should be_json_eql("{\"id\":\"#{@percolator.id}\",\"body\":\"#{@percolator.body.to_json}\"}")
		end

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
			status = get "/api/topics/1/percolators/1", valid_request, valid_session
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#status.should == 404
		end

		it "returns the expected json" do
			expect{
				get "/api/topics/1/percolators/1", valid_request, valid_session
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end
end