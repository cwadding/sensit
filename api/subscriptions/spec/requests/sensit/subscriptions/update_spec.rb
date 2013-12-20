require 'spec_helper'
describe "PUT sensit/subscriptions#update" do

	before(:each) do
		@subscription = ::Sensit::Topic::Percolator.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "3", body: { query: { query_string: { query: 'foo' } } } })
	end


	def process_request(subscription, params)
		put "/api/topics/#{subscription.type}/subscriptions/#{subscription.id}", valid_request(params), valid_session
	end

	context "with correct attributes" do

		before(:each) do
			@params = {
				:subscription => {
					:id => "foobar"
					:body => { query: { query_string: { query: 'bar' } } }
				}
			}
		end
		it "returns a 200 status code" do
			status = process_request(@subscription, @params)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@subscription, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"id\": #{params[:subscription][:id]},\"body\": #{params[:subscription][:body].to_json}}")
		end
	end
end