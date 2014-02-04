require 'spec_helper'
describe "PUT sensit/fields#update" do

	def url(topic, format ="json")
		field = topic.fields.first
		"/api/topics/#{topic.to_param}/fields/#{field.to_param}.#{format}"
	end

	def process_request(topic, params, format ="json")
		put url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	def process_oauth_request(access_grant,topic, params, format ="json")
		oauth_put access_grant, url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	context "with correct attributes" do
		before(:each) do
			@params = {
				:field => {
					:name => "New field name"
				}
			}
		end
		context "oauth authentication" do
			context "with write access to the users data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_data")
					@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
				end
				context "with a topic and fields from the application and user" do
					it "returns a 200 status code" do
						response = process_oauth_request(@access_grant,@topic, @params)
						response.status.should == 200
					end

					it "returns the expected json" do
						@field = @topic.fields.first
						response = process_oauth_request(@access_grant,@topic, @params)
						response.body.should be_json_eql("{\"key\": \"#{@field.key}\",\"name\": \"New field name\"}")
					end

					it "updates a Field" do
						@field = @topic.fields.first
						response = process_oauth_request(@access_grant,@topic, @params)
						updated_field = Sensit::Topic::Field.find(@field.id)
						updated_field.name.should == "New field name"
					end
				end
				context "updating field from another application" do
					before(:each) do
						@application = FactoryGirl.create(:application)
						topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @application)
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@topic, @params)
						@field = @topic.fields.first
						response.status.should == 200
						response.body.should be_json_eql("{\"key\": \"#{@field.key}\",\"name\": \"New field name\"}")
					end
				end

				context "updating a field owned by another user" do
					before(:each) do
						another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
						@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: another_user, application: @access_grant.application)
					end
					it "cannot read data from another user", current:true do
						expect{
							# debugger
							response = process_oauth_request(@access_grant, @topic, @params)
							response.status.should == 404
						}.to raise_error(ActiveRecord::RecordNotFound)
					end
				end				
			end
			context "with write access to only the applications data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_data")
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @application)
				end
				it "cannot update data to another application", current:true do
					expect{
						# debugger
						response = process_oauth_request(@access_grant, @topic, @params)
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
				status = process_request(@topic, @params)
				status.should == 401
			end
		end			
	end	
end