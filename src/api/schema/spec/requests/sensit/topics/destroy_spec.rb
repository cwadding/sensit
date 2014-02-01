require 'spec_helper'
describe "DELETE sensit/topics#destroy" do

	def process_oauth_request(access_grant,topic)
		oauth_delete access_grant, "/api/topics/#{topic.to_param}", valid_request, valid_session(:user_id => topic.user.to_param)
	end

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "delete_any_data")
	end

	context "when the node exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
		end
		it "is successful" do
			response = process_oauth_request(@access_grant,@topic)
			response.status.should == 204
		end

		it "deletes the Topic" do
          expect {
            response = process_oauth_request(@access_grant,@topic)
          }.to change(Sensit::Topic, :count).by(-1)
        end

        it "deletes its fields" do
			number_of_fields = @topic.fields.count
			number_of_fields.should > 0
          expect {
            response = process_oauth_request(@access_grant,@topic)
          }.to change(Sensit::Topic::Field, :count).by(-1*number_of_fields)
        end

        it "deletes its feeds" do
			if ENV['ELASTICSEARCH_URL']
				client = ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])
			else
				client = ::Elasticsearch::Client.new
			end
			number_of_feeds = @topic.feeds.count
			number_of_feeds.should > 0
			expect {
				response = process_oauth_request(@access_grant,@topic)
				client.indices.refresh(index: ELASTIC_INDEX_NAME)
			}.to change(Sensit::Topic::Feed, :count).by(-1*number_of_feeds)
        end
	end

	context "when the node does not exists" do
		it "is unsuccessful" do
			expect{
				response = oauth_delete @access_grant, "/api/topics/1", valid_request, valid_session(user_id:@user.to_param)
				response.status.should == 404
			# }.to raise_error(OAuth2::Error)
			}.to raise_error(ActiveRecord::RecordNotFound)
		end
	end  
end