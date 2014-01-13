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



	def process_request(topic)
		get "/api/topics/#{topic.to_param}", valid_request, valid_session(user_id: topic.user.to_param)
	end

	context "when the node exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, :user => @user)
		end
		it "is successful" do
			status = process_request(@topic)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@topic)
			feeds_arr = []

			@topic.feeds.each do |feed|
				data_arr = []
				feed.values.each do |key, value|
					data_arr << "\"#{key}\": #{value}"
				end
				feeds_arr << "{\"at\":#{feed.at.utc.to_f}, \"data\":{#{data_arr.join(',')}}}"
			end
			fields_arr = []
			@topic.fields.each do |field|
				fields_arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
			end
			response.body.should be_json_eql("{\"id\":1,\"description\": null,\"feeds\": [#{feeds_arr.join(',')}],\"fields\": [#{fields_arr.join(',')}],\"name\": \"#{@topic.name}\"}")
		end  
	end

	context "when the node does not exists" do
		it "is unsuccessful" do
			expect{
				status = get "/api/topics/101", valid_request, valid_session(user_id: @user.to_param)
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 400
		end

		it "returns the expected json" do
			expect{
				get "/api/topics/101", valid_request, valid_session(user_id: @user.to_param)
			}.to raise_error(ActiveRecord::RecordNotFound)
			#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end    
end