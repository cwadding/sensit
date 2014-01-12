require 'spec_helper'
describe "PUT sensit/percolators#update" do

	def process_request(percolator, params)
		put "/api/topics/#{percolator.type}/percolators/#{percolator.id}", valid_request(params), valid_session
	end

	context "with correct attributes" do

		it "returns a 200 status code" do
			@percolator = ::Sensit::Topic::Percolator.create({ type: "topic_type", id: "5", body: { query: { query_string: { query: 'foo' } } } })
			@params = {
				:percolator => {
					:id => "5",
					:body => { query: { query_string: { query: 'bar' } } }
				}
			}
			status = process_request(@percolator, @params)
			status.should == 200
		end

		it "returns the expected json" do
			@percolator = ::Sensit::Topic::Percolator.create({ type: "topic_type", id: "6", body: { query: { query_string: { query: 'foo' } } } })
			@params = {
				:percolator => {
					:id => "6",
					:body => { query: { query_string: { query: 'bar' } } }
				}
			}			
			process_request(@percolator, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"id\": \"#{@params[:percolator][:id]}\",\"body\": #{@params[:percolator][:body].to_json}}")
		end
	end
end