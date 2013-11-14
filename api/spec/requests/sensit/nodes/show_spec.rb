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

	def process_request(node)
		get "/api/nodes/#{node.id}", valid_request, valid_session
	end

	context "when the node exists" do
		before(:each) do
			@node = FactoryGirl.create(:node)
		end
		it "is successful" do
			status = process_request(@node)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@node)
			response.body.should be_json_eql('{"description": null, "name": "Node57","topics": []}')
			        
		end
	end

	context "when the node is complete" do
		before(:each) do
			@node = FactoryGirl.create(:complete_node)
		end
		it "returns the expected json" do
			process_request(@node)
			response.body.should be_json_eql('{"description": null,"name": "Node58","topics": [{"description": null,"feeds": [{"data": [{"key120": "Value120"}]}],"fields": [{"key": "key115","name": "Field115"}],"name": "Topic125"},{"description": null,"feeds": [{"data": [{"key121": "Value121"}]}],"fields": [{"key": "key116","name": "Field116"}],"name": "Topic126"},{"description": null,"feeds": [{"data": [{"key122": "Value122"}]}],"fields": [{"key": "key117","name": "Field117"}],"name": "Topic127"}]}')
		end
	end	

	context "when the node does not exists" do
		it "is unsuccessful" do
			expect{
				status = get "/api/nodes/3", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 404
		end

		it "returns the expected json" do
			expect{
				get "/api/nodes/3", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end
end