require 'spec_helper'
describe "POST sensit/subscriptions#create"  do

	def process_request(params)
		post "/api/topics/1/subscriptions", valid_request(params), valid_session
	end

	context "with correct attributes" do
		before(:each) do
			@params = {
				:subscription => {
					:name => "MyString",
					:host => "127.0.0.1"
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
			response.body.should be_json_eql("{\"id\": 1,\"name\": \"#{params[:subscription][:name]}\",\"host\": \"#{params[:subscription][:host]}\"}")
		end
	end

	context "with incorrect attributes" do

	end
end