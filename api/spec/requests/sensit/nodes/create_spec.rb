require 'spec_helper'
describe "POST sensit/nodes#create" do
   # {
   #    "node":{
   #       "name":"my nodes",
   #       "parent_id":1,//(optional) (associate parent child relationships) (self referential association)
   #       "description":"A description of the node"//(optional)
   #    }
   # }

	it "" do
		params = {}
		post "/api/nodes", valid_request(params), valid_session

	end
end