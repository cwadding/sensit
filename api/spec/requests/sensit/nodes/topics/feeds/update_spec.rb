require 'spec_helper'
describe "PUT sensit/feeds#update" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
		@feed = @topic.feeds.first
	end
	it "" do
		params = {}
		put "/api/nodes/#{@node.id}/topics/#{@topic.id}/feeds/#{@feed.id}", valid_request(params), valid_session
	end
end