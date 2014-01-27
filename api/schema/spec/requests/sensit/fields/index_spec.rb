require 'spec_helper'
describe "GET sensit/fields#index" do

	def process_oauth_request(access_grant,topic)
		oauth_get access_grant, "/api/topics/#{topic.to_param}/fields", valid_request, valid_session(:user_id => topic.user.to_param)
	end


	context "when the feed exists" do
		before(:each) do
			@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_data")
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
		end
		it "is successful" do
			response = process_oauth_request(@access_grant,@topic)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_oauth_request(@access_grant,@topic)
			fields_arr = @topic.fields.inject([]) do |arr, field|
				arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
			end
			response.body.should be_json_eql("{\"fields\": [#{fields_arr.join(',')}]}")
		end
	end
end
