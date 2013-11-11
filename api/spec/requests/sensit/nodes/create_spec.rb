require 'spec_helper'
describe "POST sensit/nodes#create" do


	it "" do
		params = {}
		post "/api/nodes", valid_request(params), valid_session

	end
end