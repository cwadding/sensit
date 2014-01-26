require 'spec_helper'
describe "POST sensit/feeds#create"  do
   # {
   #    "feed":{
   #       "timestamp":1383794969.654,
   #       "data":{
   #          "c3":0,
   #          "c4":"val",
   #          "c5":23
   #       }
   #    }
   # }

   def process_oauth_request(access_grant,topic, params)
      post "/api/topics/#{topic.to_param}/feeds", valid_request(params), valid_session
   end

   def process_oauth_request(access_grant, topic, params)
      oauth_post access_grant, "/api/topics/#{topic.to_param}/feeds", valid_request(params), valid_session
   end

   context "oauth authentication" do
      context "with write access to user data" do
         before(:each) do
            @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_data")
            @topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
         end
         context "multiple feeds" do
            context "with correct attributes" do
               it "returns a 201 status code", current: true do
                  fields = ["field1", "field2", "field3"]
                  value_set1 = {}
                  value_set2 = {}
                  value_set3 = {}
                  fields.each_with_index do |field, i|
                     value_set1.merge!(field => i)
                     value_set2.merge!(field => i*2)
                     value_set3.merge!(field => i*3)
                  end
                  params = {
                     :feeds => [{
                        :at => '2013-12-12T21:00:15.000Z',
                        :tz => "Eastern Time (US & Canada)",
                        :values => value_set1
                     },
                     {
                        :at => '2013-12-13T21:00:15.000Z',
                        :tz => "Eastern Time (US & Canada)",
                        :values => value_set2
                     },
                     {
                        :at => '2013-12-14T21:00:15.000Z',
                        :tz => "Eastern Time (US & Canada)",
                        :values => value_set3
                     }
                  ]
                  }
                  response = process_oauth_request(@access_grant, @topic, params)
                  response.status.should == 201
               end

               it "returns the expected json" do
                 fields = ["field1", "field2", "field3"]
                  value_set1 = {}
                  value_set2 = {}
                  value_set3 = {}
                  fields.each_with_index do |field, i|
                     value_set1.merge!(field => "#{i}")
                     value_set2.merge!(field => "#{i*2}")
                     value_set3.merge!(field => "#{i*3}")
                  end
                  params = {
                     :feeds => [{
                        :at => '2013-12-12T21:00:15Z',
                        :tz => "Eastern Time (US & Canada)",
                        :values => value_set1
                     },
                     {
                        :at => '2013-12-13T21:00:15Z',
                        :tz => "Eastern Time (US & Canada)",
                        :values => value_set2
                     },
                     {
                        :at => '2013-12-14T21:00:15Z',
                        :tz => "Eastern Time (US & Canada)",
                        :values => value_set3
                     }
                  ]
                  }
                  response = process_oauth_request(@access_grant,@topic, params)
                  response.body.should be_json_eql("{\"feeds\":[{\"at\": \"2013-12-12T21:00:15.000Z\",\"data\": #{value_set1.to_json}, \"tz\": \"Eastern Time (US & Canada)\"}, {\"at\": \"2013-12-13T21:00:15.000Z\",\"data\": #{value_set2.to_json}, \"tz\": \"Eastern Time (US & Canada)\"}, {\"at\": \"2013-12-14T21:00:15.000Z\",\"data\": #{value_set3.to_json}, \"tz\": \"Eastern Time (US & Canada)\"}]}")
               end
            end
         end
         context "csv file" do
            before(:each) do
            @topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
            end
            it "returns a 200 status code" do
               params = {
                  :feeds => fixture_file_upload("#{RSpec.configuration.fixture_path}/files/feeds.csv", 'text/csv')
               }
               response = process_oauth_request(@access_grant,@topic, params)
               response.status.should == 201
            end
         end

         context "zipped csv file" do
            before(:each) do
            @topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
            end
            it "returns a 201 status code" do
               params = {
                  :feeds => fixture_file_upload("#{RSpec.configuration.fixture_path}/files/feeds.zip")
               }
               response = process_oauth_request(@access_grant,@topic, params)
               response.status.should == 201
            end
         end

         context "xls file" do
            before(:each) do
            @topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
            end
            it "returns a 200 status code"
         end

         context "google spreadsheet file" do
            before(:each) do
            @topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
            end
            it "returns a 201 status code"
         end

         context "OpenOffice file" do
            before(:each) do
            @topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
            end
            it "returns a 201 status code"
         end

         context "LibreOffice" do
            before(:each) do
            @topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
            end
            it "returns a 201 status code"
         end

         context "a single feed" do

            context "with correct attributes" do
               
               it "returns a 201 status code" do
                  fields = ["field1", "field2", "field3"]
                  values = {}
                  fields.each_with_index do |field, i|
                     values.merge!(field => i)
                  end
                  params = {
                     :feed => {
                        :at => Time.now.utc.to_f,#Time.new(2013,11,14,3,56,6, "-00:00").utc.to_f,
                        :values => values
                     }
                  }
                  response = process_oauth_request(@access_grant,@topic, params)
                  response.status.should == 201
               end

               it "returns the expected json" do
                  fields = ["field1", "field2", "field3"]
                  values = {}
                  fields.each_with_index do |field, i|
                     values.merge!(field => i.to_s)
                  end
                  params = {
                     :feed => {
                        :at => Time.new(2013,11,14,3,56,6, "-00:00").utc.to_f,
                        :values => values
                     }
                  }
                  response = process_oauth_request(@access_grant,@topic, params)
                  response.body.should be_json_eql("{\"at\": \"2013-11-14T03:56:06.000Z\",\"data\": #{values.to_json},\"tz\": \"UTC\"}")
               end

               context "on first commit of fields" do
                  it "creates new fields for the data that don't exist"
               end

               # it "creates a new Feed" do
               #     expect {
               #       process_oauth_request(@access_grant,@topic, @params)
               #     }.to change(Sensit::Topic::Feed, :count).by(1)
               #   end
            end

            context "without the :at attribute" do
               before(:all) do
                  @params = {
                     :feed => {
                        :values => {"key1" => 'dsfds'}
                     }
                  }
               end

               it "is an unprocessable entity" do
                  expect{
                     response = process_oauth_request(@access_grant,@topic, @params)
                     response.status.should == 422
                  }.to raise_error(OAuth2::Error)
                  
                  
               end

               it "returns the expected json" do
                  expect{
                     response = process_oauth_request(@access_grant,@topic, @params)
                     response.body.should be_json_eql("{\"errors\":{\"at\":[\"can't be blank\"]}}")
                  }.to raise_error(OAuth2::Error)
               end
            end

            context "with a :tz attribute" do

               it "returns the expected json" do
                  fields = ["field1", "field2", "field3"]
                  values = {}
                  fields.each_with_index do |field, i|
                     values.merge!(field => i.to_s)
                  end
                  params = {
                     :feed => {
                        :at => Time.new(2013,11,14,3,56,6, "-00:00").utc.to_f,
                        :tz => "Eastern Time (US & Canada)",
                        :values => values
                     }
                  }
                  response = process_oauth_request(@access_grant,@topic, params)
                  response.body.should be_json_eql("{\"at\": \"2013-11-14T03:56:06.000Z\",\"data\": #{values.to_json}, \"tz\": \"Eastern Time (US & Canada)\"}")
               end
            end   
         end
      end
   end

end