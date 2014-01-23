require 'spec_helper'
describe "GET sensit/users#show" do

	def process_request
		get "/api/user", valid_request, valid_session
	end

	context "when the node exists" do
		it "is successful" do
			status = process_request
			status.should == 200
		end

		it "returns the expected json" do
			process_request
			response.body.should be_json_eql("{\"id\":#{@user.id},\"name\": \"#{@user.name}\"}")
		end  
	end
end