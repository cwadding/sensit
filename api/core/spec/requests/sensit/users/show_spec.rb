require 'spec_helper'
describe "GET sensit/users#show" do

	def process_oauth_request(access_grant)
		oauth_get access_grant, "/api/user", valid_request, valid_session
	end

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_data")
	end

	context "when the node exists" do
		it "is successful" do
			response = process_oauth_request(@access_grant)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_oauth_request(@access_grant)
			response.body.should be_json_eql("{\"id\":#{@user.id},\"name\": \"#{@user.name}\"}")
		end  
	end
end