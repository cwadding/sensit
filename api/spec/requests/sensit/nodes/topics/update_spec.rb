require 'spec_helper'
describe "PUT sensit/topics#update" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
	end
  it "" do
  	params = {}
    put "/api/nodes/:node_id/topics/:id", valid_request(params), valid_session

  end
end