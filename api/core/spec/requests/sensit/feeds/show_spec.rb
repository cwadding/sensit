require 'spec_helper'
describe "GET sensit/feeds#show" do

	def process_request(topic)
		feed = topic.feeds.first
		oauth_get "/api/topics/#{topic.to_param}/feeds/#{feed.id}", valid_request, valid_session(:user_id => topic.user.to_param)
	end


	context "when the feed exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
		end
		it "is successful" do
			response = process_request(@topic)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_request(@topic)
			feed = @topic.feeds.first
			data_arr = feed.values.inject([]) do |arr, (key, value)|
				arr << "{\"#{key}\": #{value}}"
			end
			response.body.should be_json_eql("{\"at\": \"#{feed.at.utc.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")}\",\"data\": #{data_arr.join(',')},\"tz\":\"UTC\"}")
		end

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
			response = oauth_get "/api/topics/1/feeds/1", valid_request, valid_session(:user_id => @user.to_param)
			response.status.should == 404
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			
		end

		it "returns the expected json" do
			expect{
				response = oauth_get "/api/topics/1/feeds/1", valid_request, valid_session(:user_id => @user.to_param)
				#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
		end
	end
end