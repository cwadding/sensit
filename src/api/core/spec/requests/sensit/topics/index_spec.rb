require 'spec_helper'
describe "GET sensit/topics#index" do

	def url(format = "json")
		"/api/topics.#{format}"
	end

  	def process_oauth_request(access_grant,params = {}, format= "json")
		oauth_get access_grant, url(format), valid_request(params.merge!(format: format)), valid_session
	end

  	def process_request(params = {}, format= "json")
		get url(format), valid_request(params.merge!(format: format)), valid_session
	end	

	context "oauth authentication" do
		context "with read access to the users data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_data")
			end	

			context "with no topics" do
				it "returns the expected json" do
					response = process_oauth_request(@access_grant)
					response.body.should be_json_eql("{\"topics\":[]}")
				end  
			end

			context "with a single topic" do
				before(:each) do

					@topic = FactoryGirl.create(:topic_with_feeds_and_fields, :description => "topic description", user: @user, application: @access_grant.application)
				end
				it "is successful" do
					response = process_oauth_request(@access_grant)
					response.status.should == 200
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant)
					# fields_arr = @topic.fields.inject([]) do |arr, field|
					# 	arr << "{\"name\":\"#{field.name}\",\"key\":\"#{field.key}\"}"
					# end
					# feeds_arr = @topic.feeds.inject([]) do |arr1, feed|
					# 	data_arr = feed.values.inject([]) do |arr2, (key, value)|
					# 		arr2 << "\"#{key}\":#{value}"
					# 	end
					# 	arr1 << "{\"at\":\"#{feed.at.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")}\",\"data\":{#{data_arr.join(',')}}}"
					# end
					# response.body.should be_json_eql("{\"topics\":[{\"id\":#{@topic.id},\"name\":\"#{@topic.name}\",\"description\":\"topic description\",\"fields\":[#{fields_arr.join(",")}],\"feeds\":[#{feeds_arr.join(",")}]}]}")
					response.body.should be_json_eql("{\"topics\":[{\"id\":#{@topic.id},\"name\":\"#{@topic.name}\",\"description\":\"topic description\"}]}")
				end
				it "returns the expected xml" do
					response = process_oauth_request(@access_grant, {}, "xml")
					pending("xml response: #{response.body}")
				end
			end

			context "with > 1 topic" do
				before(:each) do
					@topics = [FactoryGirl.create(:topic, :name => "T1", user: @user, application: @access_grant.application), FactoryGirl.create(:topic, :name => "T2", user: @user, application: @access_grant.application), FactoryGirl.create(:topic, :name => "T3", user: @user, application: @access_grant.application)]
				end
				it "returns the expected json" do
					response = process_oauth_request(@access_grant,{page:3, per:1})
					topic = @topics.last
					feeds_arr = topic.feeds.inject([]) do |arr1, feed|
						data_arr = feed.values.inject([]) do |arr2, (key, value)|
							arr2 << "\"#{key}\":#{value}"
						end
						arr1 << "{\"at\":\"#{feed.at.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")}\",\"data\":{#{data_arr.join(',')}}}"
					end
					response.body.should be_json_eql("{\"topics\":[{\"id\":#{topic.id},\"name\":\"#{topic.name}\",\"description\": null}]}")
				end  
			end
			context "a topic belonging to another application" do
				before(:each) do
                  @application = FactoryGirl.create(:application)
                  @topic = FactoryGirl.create(:topic_with_feeds, user: @user, description: "topic description",  application: @application)
				end
				it "returns the expected json" do
					response = process_oauth_request(@access_grant)
					# feeds_arr = @topic.feeds.inject([]) do |arr1, feed|
					# 	data_arr = feed.values.inject([]) do |arr2, (key, value)|
					# 		arr2 << "\"#{key}\":#{value}"
					# 	end
					# 	arr1 << "{\"at\":\"#{feed.at.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")}\",\"data\":{#{data_arr.join(',')}}}"
					# end
					response.body.should be_json_eql("{\"topics\":[{\"id\":#{@topic.id},\"name\":\"#{@topic.name}\",\"description\":\"topic description\"}]}")
				end
			end
			context "a topic belonging to another user" do
				before(:each) do
					@client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
					@another_user = Sensit::User.create(:name => "another_user", :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					@topic = FactoryGirl.create(:topic_with_feeds, user: @another_user, application: @access_grant.application)
				end
				after(:each) do
					@client.indices.flush(index: "another_user", refresh: true)
				end
				it "cannot read the data from the other user in the same application" do
					response = process_oauth_request(@access_grant)
					# feeds_arr = @topic.feeds.inject([]) do |arr1, feed|
					# 	data_arr = feed.values.inject([]) do |arr2, (key, value)|
					# 		arr2 << "\"#{key}\":#{value}"
					# 	end
					# 	arr1 << "{\"at\":\"#{feed.at.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")}\",\"data\":{#{data_arr.join(',')}}}"
					# end
					response.body.should be_json_eql("{\"topics\":[]}")
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
				response = process_oauth_request(@access_grant)
				response.status.should == 200
				response.body.should be_json_eql("{\"topics\":[]}")
            end
		end			
	end

	context "no authentication" do
		it "is unauthorized" do
			status = process_request
			status.should == 401
		end
	end 

end