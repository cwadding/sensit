require 'spec_helper'
describe "DELETE sensit/feeds#destroy" do

	def process_oauth_request(access_grant,topic)
		feed = topic.feeds.first
		oauth_delete access_grant, "/api/topics/#{topic.to_param}/feeds/#{feed.id}", valid_request, valid_session(:user_id => topic.user.to_param)
	end
	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "delete_any_data")
	end

	context "when the field exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
			@feed = @topic.feeds.first
		end
		it "is successful" do
			response = process_oauth_request(@access_grant,@topic)
			response.status.should == 204
		end

		it "deletes the Feed" do
			client = ::Elasticsearch::Client.new
			expect {
				response = process_oauth_request(@access_grant,@topic)
				client.indices.refresh(index: ELASTIC_INDEX_NAME)
			}.to change(Sensit::Topic::Feed, :count).by(-1)
        end

        it "removes that feed from the elastic_search index"

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
				response = oauth_delete @access_grant, "/api/topics/1/feeds/1", valid_request, valid_session(:user_id => @user.to_param)
				response.status.should == 404
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
		end
	end	
end