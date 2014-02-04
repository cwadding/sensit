require 'spec_helper'
describe "DELETE sensit/topics#destroy" do

	def url(topic, format = "json")
		"/api/topics/#{topic.to_param}.#{format}"
	end

	def process_oauth_request(access_grant,topic, format = "json")
		oauth_delete access_grant, url(topic, format), valid_request(format: format), valid_session
	end

	def process_request(topic, format = "json")
		delete url(topic, format), valid_request(format: format), valid_session
	end	

	context "oauth authentication" do
		context "with delete access to the users data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_data")
			end
			context "when the topic exists" do
				before(:each) do
					@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
				end
				it "is successful" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 204
				end

				it "deletes the Topic" do
		          expect {
		            response = process_oauth_request(@access_grant,@topic)
		          }.to change(Sensit::Topic, :count).by(-1)
		        end

				it "deletes its fields" do
					number_of_fields = @topic.fields.count
					number_of_fields.should > 0
					expect {
						response = process_oauth_request(@access_grant,@topic)
					}.to change(Sensit::Topic::Field, :count).by(-1*number_of_fields)
				end

		        it "deletes its feeds" do
					if ENV['ELASTICSEARCH_URL']
						client = ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])
					else
						client = ::Elasticsearch::Client.new
					end
					number_of_feeds = @topic.feeds.count
					number_of_feeds.should > 0
					expect {
						response = process_oauth_request(@access_grant,@topic)
						client.indices.refresh(index: ELASTIC_INDEX_NAME)
					}.to change(Sensit::Topic::Feed, :count).by(-1*number_of_feeds)
		        end
			end

			context "when the topic does not exists" do
				it "is unsuccessful" do
					expect{
						response = oauth_delete @access_grant, "/api/topics/1", valid_request, valid_session
						response.status.should == 404
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
					response.status.should == 204
				end
			end			
		end
		context "with delete access to only application data" do	
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_data")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)				
			end
            it "cannot delete data from another application" do
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