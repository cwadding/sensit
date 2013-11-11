require 'spec_helper'
describe "GET sensit/fields#index" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
	end
  it "" do
  	params = {}
    get "/api/nodes/#{@node.id}/topics/#{@topic.id}/fields", valid_request(params), valid_session

  end
end