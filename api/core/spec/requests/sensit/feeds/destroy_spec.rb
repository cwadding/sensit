require 'spec_helper'
describe "DELETE sensit/feeds#destroy" do

	def process_request(topic)
		feed = topic.feeds.first
		oauth_delete "/api/topics/#{topic.to_param}/feeds/#{feed.id}", valid_request, valid_session(:user_id => topic.user.to_param)
	end

	context "when the feed exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds, :user => @user, application: @application)
		end
		
		it "is successful" do
			response = process_request(@topic)
			response.status.should == 204
		end

		it "deletes the Feed" do
			client = ::Elasticsearch::Client.new
			expect {
				response = process_request(@topic)
				client.indices.refresh(:index => @user.to_param)
			}.to change(Sensit::Topic::Feed, :count).by(-1)
        end
    end
    context "when the feed does not exist" do
        it "removes that feed from the elastic_search index"

		it "is unsuccessful" do
			expect{
				response = oauth_delete "/api/topics/1/feeds/1", valid_request, valid_session(:user_id => @user.to_param)
				response.status.should == 404
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			
		end
	end	
end