require 'spec_helper'
describe "DELETE sensit/topics#destroy" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
	end
  it "" do
  	params = {}
    delete "/api/nodes/:node_id/topics/:id", valid_request(params), valid_session

  end
end