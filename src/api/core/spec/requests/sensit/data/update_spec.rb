require 'spec_helper'
describe "PUT sensit/data#update" do
# //PUT /topics/:topic_id/feeds/:feed_id/fields/:key
# {
#    "value":12
# }
	# before(:each) do
	# 	@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
	# 	@feed = @topic.feeds.first
	# 	@values = @feed.values.first
	# end
 #  it "" do
 #  	params = {}
 #    put "/api#{@topic.id}/topics/#{@topic.id}/feeds/#{@feed.id}/data/#{@data.id}", valid_request(params), valid_session

 #  end




	def url(topic)
		feed = topic.feeds.first
		key = feed.data.keys.first
		"/api/topics/#{topic.to_param}/feeds/#{feed.id}/data/#{key}"
	end

	def process_request(topic, params = {})
		put url(topic), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	def process_oauth_request(access_grant,topic, params = {})
		oauth_put access_grant, url(topic), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	context "oauth authentication" do
		context "with write access to the users data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_data")
			end
			it "returns a 200 status code" do
				topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
				params = {value: 3}
				response = process_oauth_request(@access_grant,topic, params)
				response.status.should == 200
			end

			context "writing to another application" do
				it "is successful" do
					application = FactoryGirl.create(:application)
					topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
					params = {value: 3}
					response = process_oauth_request(@access_grant,topic, params)
					response.status.should == 200
				end
			end

			context "writing a topic owned by another user" do
				before(:each) do
					@client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
					@another_user = Sensit::User.create(:name => "another_user", :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @another_user, application: @access_grant.application)
				end
				after(:each) do
					@client.indices.flush(index: "another_user", refresh: true)
				end
				it "cannot read data from another user" do
					params = {value: 3}
					expect{
						response = process_oauth_request(@access_grant, @topic, params)
						response.status.should == 404
					}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
				end
			end				
		end
		context "with write access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_data")
				application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: application)
			end
			it "cannot update data to another application" do
				params = {value: 3}
				expect{
					response = process_oauth_request(@access_grant, @topic, params)
					response.status.should == 404
				}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			end
		end			
	end
	context "no authentication" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: nil)
		end
		it "is unauthorized" do
			params = {value: 3}
			status = process_request(@topic,params)
			status.should == 401
		end
	end

end