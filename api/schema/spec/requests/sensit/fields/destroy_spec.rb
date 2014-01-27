require 'spec_helper'
describe "DELETE sensit/fields#destroy" do

	def process_oauth_request(access_grant,topic)
		field = topic.fields.first
		oauth_delete access_grant, "/api/topics/#{topic.to_param}/fields/#{field.to_param}", valid_request, valid_session(:user_id => topic.user.to_param)
	end

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "delete_any_data")
	end

	context "when the field exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
		end
		it "is successful" do
			response = process_oauth_request(@access_grant,@topic)
			response.status.should == 204
		end

		it "deletes the Field" do
          expect {
            response = process_oauth_request(@access_grant,@topic)
          }.to change(Sensit::Topic::Field, :count).by(-1)
        end

        it "removes that field from the elastic_search index"

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
				response = oauth_delete @access_grant, "/api/topics/1/fields/1", valid_request, valid_session(:user_id => @user.to_param)
				response.status.should == 404
			}.to raise_error(ActiveRecord::RecordNotFound)
		end
	end


end