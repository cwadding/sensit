require 'spec_helper'
describe "GET sensit/fields#show" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
		@field = @topic.fields.first		
	end
  it "" do
  	params = {}
    get "/api/nodes/#{@node.id}/topics/#{@topic.id}/fields/#{@field.id}", valid_request(params), valid_session

  end
end