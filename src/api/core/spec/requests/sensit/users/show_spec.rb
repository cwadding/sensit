require 'spec_helper'
describe "GET sensit/users#show" do

	def url(format = "json")
		"/api/user.#{format}"
	end

	def process_oauth_request(access_grant, format = "json")
		oauth_get access_grant, url(format), valid_request(format: format)
	end

	def process_request(format = "json")
		get url(format), valid_request(format: format), valid_session
	end	

	context "oauth authentication" do
		before(:each) do
			@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_data")
		end

		context "when the node exists" do
			it "is successful and returns the expected json" do
				response = process_oauth_request(@access_grant)
				response.status.should == 200
				response.body.should be_json_eql("{\"name\": \"#{@user.name}\", \"email\": \"#{@user.email}\", \"topics\": []}")
			end

			it "returns the expected xml" do
				response = process_oauth_request(@access_grant, "xml")
				pending("xml response: #{response.body}")				
			end
		end
	end
	context "no authentication" do
		it "is unauthorized" do
			status = process_request
			status.should == 401
		end
	end
end