require 'spec_helper'
describe "PUT sensit/topics#update" do

   def url(topic, format = "json")
      "/api/topics/#{topic.id}.#{format}"
   end

   def process_oauth_request(access_grant,topic, params = {}, format = "json")
      oauth_put access_grant, url(topic,format), valid_request(params.merge!(format:format)), valid_session
   end

   def process_request(topic, params = {}, format = "json")
      put url(topic,format), valid_request(params.merge!(format:format)), valid_session
   end

   context "with valid attributes" do
      before(:each) do
         @params = {
            :topic => {
               :name => "New topic name",
               :description => "new description"
            }
         }
      end
      context "oauth authentication" do
         context "with write access to the users data" do
            before(:each) do
               @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_data")
               @topic = FactoryGirl.create(:topic_with_feeds_and_fields, :user => @user, application: @access_grant.application)
            end


            it "returns a 200 status code" do
               response = process_oauth_request(@access_grant,@topic, @params)
               response.status.should == 200
            end

            it "returns the expected json" do
               response = process_oauth_request(@access_grant,@topic, @params)
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
               response.body.should be_json_eql("{\"id\":1,\"description\": \"#{@params[:topic][:description]}\",\"feeds\": [#{feeds_arr.join(',')}],\"fields\": [#{fields_arr.join(',')}],\"name\": \"#{@params[:topic][:name]}\"}")
            end

            it "returns the expected xml" do
               pending("xml response")
               response = process_oauth_request(@access_grant, @topic, @params, "xml")
            end

            it "updates the existing Topic" do
      			response = process_oauth_request(@access_grant,@topic, @params)
      			updated_topic = Sensit::Topic.find(@topic.id)
      			updated_topic.name.should == "New topic name"
      			updated_topic.description.should == "new description"
            end

            context "with fields" do
               before(:each) do
                  fields_arr = []
                  @topic.fields.each do |field|
                     fields_arr << {key: field.key, name: "New#{field.name}"}
                  end
                  @params[:topic].merge!({:fields => fields_arr})
               end
               it "returns the expected json" do
                  response = process_oauth_request(@access_grant,@topic, @params)
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
                     fields_arr << "{\"key\": \"#{field.key}\",\"name\": \"New#{field.name}\"}"
                  end
                  response.body.should be_json_eql("{\"id\":1,\"description\": \"#{@params[:topic][:description]}\",\"feeds\": [#{feeds_arr.join(',')}],\"fields\": [#{fields_arr.join(',')}],\"name\": \"#{@params[:topic][:name]}\"}")

               end       
            end

            context "with ttl" do
               before(:each) do
                  @params[:topic].merge!({:ttl => 2.days.to_i})
               end

               it "returns the expected json" do
                  response = process_oauth_request(@access_grant,@topic, @params)
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
                  response.body.should be_json_eql("{\"id\":1,\"description\": \"#{@params[:topic][:description]}\",\"feeds\": [#{feeds_arr.join(',')}],\"fields\": [#{fields_arr.join(',')}],\"name\": \"#{@params[:topic][:name]}\"}")
               end

               it "returns the expected xml" do
                  response = process_oauth_request(@access_grant, @topic, @params, "xml")
                  pending("xml response: #{response.body}")
               end

               it "updates the ttl of the existing Topic" do
                  response = process_oauth_request(@access_grant,@topic, @params)
                  updated_topic = Sensit::Topic.find(@topic.id)
                  updated_topic.ttl.should == 172800
               end
               it "updates the ttl on each of the feeds" do
                  response = process_oauth_request(@access_grant,@topic, @params)
                  updated_topic = Sensit::Topic.find(@topic.id)
                  updated_topic.feeds.each do |feed|
                     feed.ttl.should == 172800
                  end
               end      
            end

            context "writing to another application" do
               before(:each) do
                  @application = FactoryGirl.create(:application)
                  @topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
               end

               it "updates the topic in the application" do
                  response = process_oauth_request(@access_grant,@topic, @params)
                  response.status.should == 200
                  
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
                  response.body.should be_json_eql("{\"id\":1,\"description\": \"#{@params[:topic][:description]}\",\"feeds\": [#{feeds_arr.join(',')}],\"fields\": [#{fields_arr.join(',')}],\"name\": \"#{@params[:topic][:name]}\"}")
                  # @application.topics.first.name == "New topic name"
                  # @application.topics.first.description == "new description"
               end
            end

            context "writing a topic owned by another user" do
               before(:each) do
                  @another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
                  @topic = FactoryGirl.create(:topic_with_feeds, user: @another_user, application: @access_grant.application)
               end
               it "cannot read data from another user" do
                  expect{
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
               @topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
            end
            it "cannot update data to another application" do
               expect{
                  response = process_oauth_request(@access_grant, @topic, @params)
                  response.status.should == 404
               }.to raise_error(ActiveRecord::RecordNotFound)
            end
         end
      end
      context "no authentication" do
         before(:each) do
            @topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: nil)
         end
         it "is unauthorized" do
            status = process_request(@topic, @params)
            status.should == 401
         end
      end
   end

end