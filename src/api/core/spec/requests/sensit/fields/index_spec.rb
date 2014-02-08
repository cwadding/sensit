require 'spec_helper'
describe "GET sensit/fields#index" do

	def url(topic, format ="json")
		"/api/topics/#{topic.to_param}/fields.#{format}"
	end

	def process_oauth_request(access_grant,topic, format ="json")
		oauth_get access_grant, url(topic, format), valid_request, valid_session(:user_id => topic.user.to_param)
	end

	def process_request(topic, format ="json")
		get url(topic, format), valid_request, valid_session(:user_id => topic.user.to_param)
	end	

	context "oauth authentication" do
		context "with write access to the users percolator data" do
			context "when the feed exists" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_data")					
				end

				context "with no fields" do
					before(:each) do
						@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
					end
					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@topic)
						response.body.should be_json_eql("{\"fields\": []}")
					end
				end

				context "with fields" do
					before(:each) do
						@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
					end
					it "is successful" do
						response = process_oauth_request(@access_grant,@topic)
						response.status.should == 200
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@topic)
						fields_arr = @topic.fields.inject([]) do |arr, field|
							arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
						end
						response.body.should be_json_eql("{\"fields\": [#{fields_arr.join(',')}]}")
					end
				end
				context "reading reports from another application" do
					before(:each) do
						@application = FactoryGirl.create(:application)
						@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @application)
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@topic)
						response.status.should == 200
						fields_arr = @topic.fields.inject([]) do |arr, field|
							arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
						end
						response.body.should be_json_eql("{\"fields\": [#{fields_arr.join(',')}]}")
					end
				end

				context "with a report owned by another user" do
					before(:each) do
						@client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
						another_user = Sensit::User.create(:name => "another_user", :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
						@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: another_user, application: @access_grant.application)
					end
					after(:each) do
						@client.indices.flush(index: "another_user", refresh: true)
					end	
					it "cannot read data from another user" do
						response = process_oauth_request(@access_grant, @topic)
						response.body.should be_json_eql("{\"fields\": []}")
					end
				end				
			end
		end
		context "with read access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_application_data")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @application)
			end
			it "cannot read data of other application" do
				response = process_oauth_request(@access_grant, @topic)
				response.body.should be_json_eql("{\"fields\":[]}")
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
