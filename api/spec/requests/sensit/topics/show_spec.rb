require 'spec_helper'
describe "GET sensit/topics#show" do
# {
#    "topic":{
#          "id":2,
#          "name":"my_topic2",
#          "fields":[
#             {
#                "field":{
#                   "name":"col3",
#                   "key":"c3",
#                   "unit":"mm",
#                   "datatype":"integer"
#                },
#                "field":{
#                   "name":"col5",
#                   "key":"c5",
#                   "unit":"filename",
#                   "datatype":"string"
#                },
#                "field":{
#                   "name":"col4",
#                   "key":"c4",
#                   "unit":"s",
#                   "datatype":"float"
#                }
#             }
#          ],
#          "feeds":[
#             {
#                "feed":{
#                   "id": 3,
#                   "timestamp":1383794969.654,
#                   "data":{
#                      "c3":0,
#                      "c4":"val",
#                      "c5":23
#                   }
#                },
#                "feed":{
#                   "id": 4,
#                   "timestamp":1383794970.456,
#                   "data":{
#                      "c3":0,
#                      "c4":"val32",
#                      "c5":45
#                   }
#                }
#             }
#          ]
#       }
#    }   
# }
	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
	end
  it "" do
  	params = {}
    get "/api/nodes/:node_id/topics/:id", valid_request(params), valid_session

  end
end