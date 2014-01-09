require 'spec_helper'
describe "GET sensit/topics#show" do

	def process_request(topic)
		get "/api/topics/#{topic.id}", valid_request, valid_session
	end

	context "when the node exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds)
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
				feeds_arr << "{\"at\":\"#{feed.at.utc.iso8601}\", \"data\":{#{data_arr.join(',')}}}"
			end
			response.body.should be_json_eql("{\"id\":1,\"description\": null,\"feeds\": [#{feeds_arr.join(',')}],\"name\": \"#{@topic.name}\"}")
		end  
	end

	context "when the node does not exists" do
		it "is unsuccessful" do
			expect{
				status = get "/api/topics/101", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 400
		end

		it "returns the expected json" do
			expect{
				get "/api/topics/101", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end    
end