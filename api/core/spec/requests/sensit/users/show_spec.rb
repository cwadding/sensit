require 'spec_helper'
describe "GET sensit/users#show" do

	def process_request
		oauth_get "/api/user", valid_request, valid_session
	end

	context "when the node exists" do
		it "is successful" do
			response = process_request
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_request
			response.body.should be_json_eql("{\"id\":#{@user.id},\"name\": \"#{@user.name}\"}")
		end  
	end
end