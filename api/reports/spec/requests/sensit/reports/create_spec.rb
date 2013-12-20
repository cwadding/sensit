require 'spec_helper'
describe "POST sensit/reports#create"  do

	def process_request(params)
		post "/api/topics/1/reports", valid_request(params), valid_session
	end

	context "with correct attributes" do
		before(:each) do
			@params = {
				:report => {
					:name => "My Report",
					:query => { "statistical" => { "field" => "num1"}}
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
			response.body.should be_json_eql("{\"name\": #{params[:report][:name]},\"query\": #{params[:report][:query].to_json}}")
		end
	end

	context "with incorrect attributes" do

	end
end