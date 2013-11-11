require 'spec_helper'
describe "GET sensit/nodes#show" do

# {
#    "node":{
#       "id":1,
#       "name":"my_node",
#       "description":"the description of the node",
#       "topics":[
#          {
#             "topic":{
#                "id":1,
#                "name":"my_topic",
#                "description":"the description of the node",
#                "fields":[
#                   {
#                      "field":{
#                         "name":"col1",
#                         "key":"c1",
#                         "unit":"s",
#                         "datatype":"integer"
#                      },
#                      "field":{
#                         "name":"col2",
#                         "key":"c2",
#                         "unit":"filename",
#                         "datatype":"string"
#                      },
#                      "field":{
#                         "name":"col3",
#                         "key":"c2",
#                         "unit":"m",
#                         "datatype":"float"
#                      }
#                   }
#                ],
#                "feeds":[
#                   {
#                      "feed":{
#                         "id": 1,
#                         "timestamp":1383794969.123,
#                         "data":{
#                            "c1":0,
#                            "c2":"val",
#                            "c3":23
#                         }
#                      },
#                      "feed":{
#                         "id": 2,
#                         "timestamp":1383794970.234,
#                         "data":{
#                            "c1":0,
#                            "c2":"val3",
#                            "c3":45
#                         }
#                      }
#                   }
#                ]
#             },
#             "topic":{
#                "id":2,
#                "name":"my_topic2",
#                "fields":[
#                   {
#                      "field":{
#                         "name":"col3",
#                         "key":"c3",
#                         "unit":"mm",
#                         "datatype":"integer"
#                      },
#                      "field":{
#                         "name":"col5",
#                         "key":"c5",
#                         "unit":"filename",
#                         "datatype":"string"
#                      },
#                      "field":{
#                         "name":"col4",
#                         "key":"c4",
#                         "unit":"s",
#                         "datatype":"float"
#                      }
#                   }
#                ],
#                "feeds":[
#                   {
#                      "feed":{
#                         "id": 3,
#                         "timestamp":1383794969.345,
#                         "data":{
#                            "c3":0,
#                            "c4":"val",
#                            "c5":23
#                         }
#                      },
#                      "feed":{
#                         "id": 4,
#                         "timestamp":1383794970.234,
#                         "data":{
#                            "c3":0,
#                            "c4":"val32",
#                            "c5":45
#                         }
#                      }
#                   }
#                ]
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
    get "/api/nodes/#{@node.id}", valid_request(params), valid_session

  end
end