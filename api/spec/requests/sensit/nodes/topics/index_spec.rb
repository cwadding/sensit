require 'spec_helper'
describe "GET sensit/topics#index" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
	end
  it "" do
  	params = {}
    get "/api/nodes/:node_id/topics", valid_request(params), valid_session

  end
end