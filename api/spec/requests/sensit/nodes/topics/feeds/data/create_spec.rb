require 'spec_helper'
describe "POST sensit/data#create" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
		@feed = @topic.feeds.first
	end
	it "" do
		params = {}
		post "/api/nodes/#{@node.id}/topics/#{@topic.id}/feeds/#{@feed.id}/data", valid_request(params), valid_session
	end
end