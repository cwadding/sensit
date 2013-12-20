require 'spec_helper'
describe "POST sensit/subscriptions#create"  do

	def process_request(params)
		post "/api/topics/1/subscriptions", valid_request(params), valid_session
	end

	context "with correct attributes" do
		before(:each) do
			@params = {
				:subscription => {
					:id => "foobar"
					:body => { query: { query_string: { query: 'foo' } } }
				}
			}
		end
		it "returns a 200 status code" do
			status = process_request(@params)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"id\": #{params[:subscription][:id]},\"body\": #{params[:subscription][:body].to_json}}")
		end
	end

	context "with incorrect attributes" do

	end
end