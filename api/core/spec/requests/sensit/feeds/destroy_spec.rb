require 'spec_helper'
describe "DELETE sensit/feeds#destroy" do

	def process_request(topic)
		feed = topic.feeds.first
		delete "/api/topics/#{topic.to_param}/feeds/#{feed.id}", valid_request, valid_session
	end

	context "when the field exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds)
			@feed = @topic.feeds.first
		end
		
		it "is successful", :current => true do
			status = process_request(@topic)
			status.should == 204
		end

		it "deletes the Feed" do
			client = ::Elasticsearch::Client.new
			expect {
				process_request(@topic)
				client.indices.refresh(:index => ELASTIC_SEARCH_INDEX_NAME)
			}.to change(Sensit::Topic::Feed, :count).by(-1)
        end

        it "removes that feed from the elastic_search index"

		it "is unsuccessful" do
			expect{
				status = delete "/api/topics/1/feeds/1", valid_request, valid_session
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#status.should == 404
		end
	end	
end