require 'spec_helper'
describe "GET sensit/feeds#show" do
# {
#    "feed":{
#       "id": 3,
#       "fields":[
#          {
#             "field":{
#                "name":"col3",
#                "key":"c3",
#                "unit":"mm",
#                "datatype":"integer"
#             },
#             "field":{
#                "name":"col5",
#                "key":"c5",
#                "unit":"filename",
#                "datatype":"string"
#             },
#             "field":{
#                "name":"col4",
#                "key":"c4",
#                "unit":"s",
#                "datatype":"float"
#             }
#          }
#       ],
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
		@feed = @topic.feeds.first
	end
	it "" do
		params = {}
		get "/api/nodes/#{@node.id}/topics/#{@topic.id}/feeds/#{@feed.id}", valid_request(params), valid_session
	end
end