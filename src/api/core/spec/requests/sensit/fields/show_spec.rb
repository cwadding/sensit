require 'spec_helper'
describe "GET sensit/fields#show" do

	def url(topic, format="json")
		field = @topic.fields.first
		"/api/topics/#{topic.to_param}/fields/#{field.to_param}.#{format}"
	end

	def process_request(topic, format="json")
		get url(topic, format), valid_request, valid_session(:user_id => topic.user.to_param)
	end

	def process_oauth_request(access_grant,topic, format="json")
		oauth_get access_grant, url(topic, format), valid_request, valid_session(:user_id => topic.user.to_param)
	end

	context "oauth authentication" do
		context "with read access to the users percolator data" do	
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_data")
			end
			context "when the field exists" do
				before(:each) do
					@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
				end
				it "is successful" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					field = @topic.fields.first
					response.body.should be_json_eql("{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}")
				end
			end

			context "when the field does not exist" do
				it "is unsuccessful" do
					expect{
						response = oauth_get @access_grant, "/api/topics/1/fields/1", valid_request, valid_session(:user_id => @user.to_param)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
				end

				it "returns the expected json" do
					expect{
						response = oauth_get @access_grant, "/api/topics/1/fields/1", valid_request, valid_session
						response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
					}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end

			context "reading field from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @application)
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
					field = @topic.fields.first
					response.body.should be_json_eql("{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}")
				end
			end

			context "reading a report owned by another user" do
				before(:each) do
					another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: another_user, application: @access_grant.application)
				end
				it "cannot read data from another user" do
					expect{
						response = process_oauth_request(@access_grant, @topic)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end				
		end
		context "with read access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_application_data")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @application)
			end
			it "cannot read data to another application" do
				expect{
					response = process_oauth_request(@access_grant, @topic)
					response.status.should == 404
				}.to raise_error(ActiveRecord::RecordNotFound)
			end
		end			
	end

	context "no authentication" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: nil)
		end
		it "is unauthorized" do
			status = process_request(@topic)
			status.should == 401
		end
	end		
end

