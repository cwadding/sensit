require 'spec_helper'
describe "GET sensit/topics#show" do

	def url(topic, format = "json")
		"/api/topics/#{topic.id}.#{format}"
	end

	def process_oauth_request(access_grant,topic, format="json")
		oauth_get access_grant, url(topic,format), valid_request(format: format), valid_session
	end

	def process_request(topic, format="json")
		get url(topic,format), valid_request(format: format), valid_session
	end	

	context "oauth authentication" do
		context "with read access to the users data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_data")
			end	
			context "a topic belonging to the current application" do
				before(:each) do
					@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
				end
				it "is successful" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					feeds_arr = []

					@topic.feeds.each do |feed|
						data_arr = []
						feed.data.each do |key, value|
							data_arr << "\"#{key}\": #{value}"
						end
						feeds_arr << "{\"at\":\"#{feed.at.utc.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")}\", \"data\":{#{data_arr.join(',')}}, \"tz\": \"UTC\"}"
					end
					fields_arr = []
					@topic.fields.each do |field|
						fields_arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
					end
					response.body.should be_json_eql("{\"id\":1,\"description\": null,\"feeds\": [#{feeds_arr.join(',')}],\"fields\": [#{fields_arr.join(',')}],\"name\": \"#{@topic.name}\"}")
				end

				it "returns the expected xml" do
					response = process_oauth_request(@access_grant, @topic, "xml")
					pending("xml response: #{response.body}")
				end
			end
			context "a topic that doesn't exist" do
				it "is unsuccessful" do
					expect{
						response = oauth_get @access_grant, "/api/topics/101", valid_request, valid_session
						# response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
					
				end

				it "returns the expected json" do
					expect{
						response = oauth_get @access_grant, "/api/topics/101", valid_request, valid_session
						# response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
					}.to raise_error(ActiveRecord::RecordNotFound)
					
				end
			end

			context "a topic belonging to another user" do
				before(:each) do
					@another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					@topic = FactoryGirl.create(:topic_with_feeds, user: @another_user, application: @access_grant.application)
				end
				it "cannot read data from another user" do
				expect{
					response = process_oauth_request(@access_grant, @topic)
					response.status.should == 404
				}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end

			context "a topic belonging to another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
				end
				it "is successful" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
				end
			end
		end
		context "with read access to only application data" do	
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_application_data")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)				
			end
			it "cannot read data from another application" do
				expect{
					response = process_oauth_request(@access_grant, @topic)
					response.status.should == 404
				}.to raise_error(ActiveRecord::RecordNotFound)
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