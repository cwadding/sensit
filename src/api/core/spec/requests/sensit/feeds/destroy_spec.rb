require 'spec_helper'
describe "DELETE sensit/feeds#destroy" do

	def url(topic, format = "json")
		feed = topic.feeds.first
		"/api/topics/#{topic.to_param}/feeds/#{feed.id}.#{format}"
	end

	def process_oauth_request(access_grant,topic, format="json")
		oauth_delete access_grant, url(topic,format), valid_request(format: format), valid_session(:user_id => topic.user.to_param)
	end

	def process_request(topic, format="json")
		delete url(topic,format), valid_request(format: format), valid_session(:user_id => topic.user.to_param)
	end	

	context "oauth authentication" do
		context "with delete access to the users data" do

			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_data")
			end
			context "when the feed exists" do
				before(:each) do
					@topic = FactoryGirl.create(:topic_with_feeds, :user => @user, application: @access_grant.application)
				end
				
				it "is successful" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 204
				end

				it "deletes the Feed" do
					client = ENV['ELASTICSEARCH_URL'] ? ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL']) : ::Elasticsearch::Client.new
					expect {
						response = process_oauth_request(@access_grant,@topic)
						client.indices.refresh(index: ELASTIC_INDEX_NAME)
					}.to change(Sensit::Topic::Feed, :count).by(-1)
		        end
			end
			context "when the feed does not exist" do
				it "removes that feed from the elastic_search index"

				it "is unsuccessful" do
					expect{
						response = oauth_delete @access_grant, "/api/topics/1/feeds/1", valid_request, valid_session(:user_id => @user.to_param)
						response.status.should == 404
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
					response.status.should == 204
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
		context "with delete access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_data")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
			end
			it "cannot delete data of another application" do
				expect{
					response = process_oauth_request(@access_grant, @topic)
					response.status.should == 404
				}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			end
		end		
	end

	context "no authentication" do
		it "is unauthorized" do
			topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: nil)
			status = process_request(topic)
			status.should == 401
		end
	end	
end