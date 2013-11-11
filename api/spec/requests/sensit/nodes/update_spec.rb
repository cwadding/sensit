require 'spec_helper'
describe "PUT sensit/nodes#update" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
	end
  it "" do
  	params = {}
    put "/api/nodes/#{@node.id}", valid_request(params), valid_session

  end
end