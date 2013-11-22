require 'spec_helper'
describe "DELETE sensit/feeds#destroy" do

	def process_request(node)
		topic = @node.topics.first
		feed = topic.feeds.first
		delete "/api/nodes/#{node.id}/topics/#{topic.id}/feeds/#{feed.id}", valid_request, valid_session
	end

	context "when the field exists" do
		before(:each) do
			@node = FactoryGirl.create(:complete_node)
			@topic = @node.topics.first
			@feed = @topic.feeds.first
		end
		it "is successful" do
			status = process_request(@node)
			status.should == 204
		end

		it "deletes the Feed" do
			client = ::Elasticsearch::Client.new
          expect {
            process_request(@node)
            client.indices.refresh(:index => ELASTIC_SEARCH_INDEX_NAME)
          }.to change(Sensit::Node::Topic::Feed, :count).by(-1)
        end

        it "removes that feed from the elastic_search index"

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
				status = delete "/api/nodes/1/topics/1/feeds/1", valid_request, valid_session
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#status.should == 404
		end
	end	
end