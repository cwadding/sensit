require 'spec_helper'
describe "GET sensit/nodes#index" do

	def process_request(params)
		get "/api/nodes", valid_request(params), valid_session
	end


	context "when the node exists" do
		before(:each) do
			@node = FactoryGirl.create(:complete_node)
		end
		it "is successful" do
			status = process_request(@node)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@node)
			response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end

end