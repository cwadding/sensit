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



	def process_request(node)
		topic = node.topics.first
		get "/api/nodes/#{node.id}/topics/#{topic.id}", valid_request, valid_session
	end

	context "when the node exists" do
		before(:each) do
			@node = FactoryGirl.create(:complete_node)
			@topic = @node.topics.first
		end
		it "is successful" do
			status = process_request(@node)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@node)
			response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end  
	end

	context "when the node does not exists" do
		it "is unsuccessful" do
			expect{
				status = get "/api/nodes/1/topics/1", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 400
		end

		it "returns the expected json" do
			expect{
				get "/api/nodes/1/topics/1", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end    
end