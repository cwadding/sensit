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

	def process_request(node)
		topic = @node.topics.first
		feed = topic.fields.first
		get "/api/nodes/#{node.id}/topics/#{topic.id}/feeds/#{feed.id}", valid_request, valid_session
	end


	context "when the feed exists" do
		before(:each) do
			@node = FactoryGirl.create(:complete_node)
		end
		it "is successful" do
			status = process_request(@node)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@node)
			topic = @node.topics.first
			feed = topic.feeds.first
			field_arr = topic.fields.inject([]) do |arr, field|
				arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
			end
			data_arr = feed.data_rows.inject([]) do |arr, datum|
				arr << "{\"#{datum.key}\": \"#{datum.value}\"}"
			end
			response.body.should be_json_eql("{\"at\": \"#{topic.feeds.first.at.strftime("%Y-%m-%dT%H:%M:%S.000Z")}\",\"data\": [#{data_arr.join(',')}],\"fields\": [#{field_arr.join(',')}]}")
		end

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
			status = get "/api/nodes/1/topics/1/feeds/1", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 404
		end

		it "returns the expected json" do
			expect{
				get "/api/nodes/1/topics/1/feeds/1", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			
			#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end
end