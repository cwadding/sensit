require 'spec_helper'
describe "PUT sensit/fields#update" do

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_data")
		@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
		@field = @topic.fields.first
	end


	def process_oauth_request(access_grant,topic, params)
		field = topic.fields.first
		oauth_put access_grant, "/api/topics/#{topic.to_param}/fields/#{field.to_param}", valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	context "with correct attributes" do
		before(:all) do
			@params = {
				:field => {
					:name => "New field name"
				}
			}
		end
		
		it "returns a 200 status code" do
			response = process_oauth_request(@access_grant,@topic, @params)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_oauth_request(@access_grant,@topic, @params)
			response.body.should be_json_eql("{\"key\": \"#{@field.key}\",\"name\": \"New field name\"}")
		end

		it "updates a Field" do
			response = process_oauth_request(@access_grant,@topic, @params)
			updated_field = Sensit::Topic::Field.find(@field.id)
			updated_field.name.should == "New field name"
		end
	end	
end