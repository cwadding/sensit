require 'spec_helper'
describe "GET sensit/topics#show" do
	def process_request(topic)
		oauth_get "/api/topics/#{topic.to_param}", valid_request, valid_session(user_id: topic.user.to_param)
	end

	context "when the node exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, :user => @user, application: @application)
		end
		it "is successful" do
			response = process_request(@topic)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_request(@topic)
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
				response = oauth_get "/api/topics/101", valid_request, valid_session(user_id: @user.to_param)
				response.status.should == 400
			}.to raise_error(ActiveRecord::RecordNotFound)
			#
		end

		it "returns the expected json" do
			expect{
				response = oauth_get "/api/topics/101", valid_request, valid_session(user_id: @user.to_param)
				response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
			}.to raise_error(ActiveRecord::RecordNotFound)
		end
	end    
end