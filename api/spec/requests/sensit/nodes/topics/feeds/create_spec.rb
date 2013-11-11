require 'spec_helper'
describe "POST sensit/feeds#create" do
   # {
   #    "feed":{
   #       "timestamp":1383794969.654,
   #       "data":{
   #          "c3":0,
   #          "c4":"val",
   #          "c5":23
   #       }
   #    }
   # }
	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
	end
	it "" do
		params = {}
		post "/api/nodes/#{@node.id}/topics/#{@topic.id}/feeds", valid_request(params), valid_session

	end
end