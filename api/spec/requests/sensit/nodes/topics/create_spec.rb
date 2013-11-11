require 'spec_helper'
describe "POST sensit/topics#create" do
   # {
   #    "topic":{
   #       "name":"my_topic2",
   #       "fields":[
   #          {
   #             "0":{
   #                "name":"col3",
   #                "key":"c3",
   #                "unit":"mm",
   #                "datatype":"integer"
   #             },
   #             "1":{
   #                "name":"col5",
   #                "key":"c5",
   #                "unit":"filename",
   #                "datatype":"string"
   #             },
   #             "2":{
   #                "name":"col4",
   #                "key":"c4",
   #                "unit":"s",
   #                "datatype":"float"
   #             }
   #          }
   #       ]
   #    }
   # }
	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
	end
	it "" do
		params = {}
		post "/api/nodes/:node_id/topics", valid_request(params), valid_session

	end
end