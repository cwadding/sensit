require 'spec_helper'
describe "POST sensit/percolators#create"  do

	def process_request(params)
		post "/api/topics/1/percolators", valid_request(params), valid_session
	end

	context "with correct attributes" do
		it "returns a 200 status code" do
			@params = {
				:percolator => {
					:id => "foo",
					:body => { query: { query_string: { query: 'foo' } } }
				}
			}
			status = process_request(@params)
			status.should == 201
		end

		it "returns the expected json" do
			@params = {
				:percolator => {
					:id => "bar",
					:body => { query: { query_string: { query: 'bar' } } }
				}
			}
			process_request(@params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"id\": \"#{@params[:percolator][:id]}\",\"body\": #{@params[:percolator][:body].to_json}}")
		end
	end

	context "with incorrect attributes" do

	end
end