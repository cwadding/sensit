require 'spec_helper'
describe "DELETE sensit/nodes#destroy" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
	end
  it "" do
  	params = {}
    delete "/api/nodes/#{@node.id}", valid_request(params), valid_session

  end
end