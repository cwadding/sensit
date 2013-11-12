require 'spec_helper'
describe "POST sensit/fields#create" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
		@field = @topic.fields.first		
	end
	it "" do
		params = {}
		post "/api/nodes/#{@node.id}/topics/#{@topic.id}/fields", valid_request(params), valid_session

	end
end