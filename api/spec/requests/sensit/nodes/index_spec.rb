require 'spec_helper'
describe "GET sensit/nodes#index" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
	end
  it "" do
  	params = {}
    get "/api/nodes", valid_request(params), valid_session

  end
end