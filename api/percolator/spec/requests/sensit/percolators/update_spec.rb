require 'spec_helper'
describe "PUT sensit/percolators#update" do

	before(:each) do
		@percolator = ::Sensit::Topic::Percolator.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "3", body: { query: { query_string: { query: 'foo' } } } })
	end


	def process_request(percolator, params)
		put "/api/topics/#{percolator.type}/percolators/#{percolator.id}", valid_request(params), valid_session
	end

	context "with correct attributes" do

		before(:each) do
			@params = {
				:percolator => {
					:id => "foobar"
					:body => { query: { query_string: { query: 'bar' } } }
				}
			}
		end
		it "returns a 200 status code" do
			status = process_request(@percolator, @params)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@percolator, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"id\": #{params[:percolator][:id]},\"body\": #{params[:percolator][:body].to_json}}")
		end
	end
end