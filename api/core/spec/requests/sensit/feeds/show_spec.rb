require 'spec_helper'
describe "GET sensit/feeds#show" do

	def process_oauth_request(access_grant,topic, format = "json")
		feed = topic.feeds.first
		oauth_get access_grant, "/api/topics/#{topic.to_param}/feeds/#{feed.id}.#{format}", valid_request(format: format), valid_session(:user_id => topic.user.to_param)
	end

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_data")
	end
	context "when the feed exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
		end
		it "is successful" do
			# debugger
			response = process_oauth_request(@access_grant,@topic)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_oauth_request(@access_grant,@topic)
			feed = @topic.feeds.first
			data_arr = feed.values.inject([]) do |arr, (key, value)|
				arr << "{\"#{key}\": #{value}}"
			end
			response.body.should be_json_eql("{\"at\": \"#{feed.at.utc.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")}\",\"data\": #{data_arr.join(',')},\"tz\":\"UTC\"}")
		end

		it "returns the expected xml" do
			pending("xml response")
			response = process_oauth_request(@access_grant, @topic, "xml")
		end

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
			response = oauth_get @access_grant, "/api/topics/1/feeds/1", valid_request, valid_session(:user_id => @user.to_param)
			response.status.should == 404
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			
		end

		it "returns the expected json" do
			expect{
				response = oauth_get @access_grant, "/api/topics/1/feeds/1", valid_request, valid_session(:user_id => @user.to_param)
				#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
		end
	end
end