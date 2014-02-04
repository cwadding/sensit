require 'spec_helper'
describe "GET sensit/data#show" do

	def url(topic)
		feed = topic.feeds.first
		key = feed.data.keys.first
		"/api/topics/#{topic.to_param}/feeds/#{feed.id}/data/#{key}"
	end

	def process_oauth_request(access_grant,topic)
		oauth_get access_grant, url(topic), valid_request, valid_session(:user_id => topic.user.to_param)
	end

	def process_request(topic)
		get url(topic), valid_request, valid_session(:user_id => topic.user.to_param)
	end	

	context "oauth authentication" do
		context "with read access to any data by the user data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_data")
			end
			context "when the feed exists" do
				before(:each) do
					@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
				end
				it "is successful" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
				end

				it "returns the expected value" do
					response = process_oauth_request(@access_grant,@topic)
					feed = @topic.feeds.first
					key = feed.data.keys.first
					response.body.should == feed.data[key].to_s
				end
			end

			context "when the field does not exist" do
				it "is unsuccessful" do
					expect{
						response = oauth_get @access_grant, "/api/topics/1/feeds/1/data/asdds", valid_request, valid_session(:user_id => @user.to_param)
						response.status.should == 404
					}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
				end

				it "raises a NotFound exception" do
					expect{
						response = oauth_get @access_grant, "/api/topics/1/feeds/1/data/afdsa", valid_request, valid_session(:user_id => @user.to_param)
					}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
				end
			end
			context "a feed from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
				end

				it "is successful" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
				end
			end

			context "a feed from another user" do
				before(:each) do
					@another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "another_user@example.com", :password => "password", :password_confirmation => "password")
					@topic = FactoryGirl.create(:topic_with_feeds, user: @another_user, application: @access_grant.application)
				end
				it "cannot read data from another user" do
					expect{
						response = process_oauth_request(@access_grant, @topic)
						response.status.should == 404
					}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
				end
			end
		end
		context "with read access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_application_data")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
			end
			it "cannot read data of another application" do
				expect{
					response = process_oauth_request(@access_grant, @topic)
					response.status.should == 404
				}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			end
		end
	end

	context "no authentication" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: nil)
		end
		it "is unauthorized" do
			status = process_request(@topic)
			status.should == 401
		end
	end	

end