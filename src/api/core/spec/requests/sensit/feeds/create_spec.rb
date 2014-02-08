require 'spec_helper'
require 'net/http/post/multipart'
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

   def url(topic, format = "json")
      "/api/topics/#{topic.to_param}/feeds.#{format}"
   end

   def process_multipart_oauth_request(access_grant, topic, file_path, format = "json")
      url = URI.parse("http://example.com/#{url(topic,format)}")
      File.open(file_path) do |f|
        req = Net::HTTP::Post::Multipart.new url.path,
          "feeds" => UploadIO.new(f, "image/jpeg", "image.jpg")

        # here you include the token in headers
        req['Authorization'] = "Bearer #{access_grant.token}"
        res = Net::HTTP.start(url.host) do |http|
          http.request(req)
        end
      end
   end

   def process_request(topic, params = {}, format = "json")
      post url(topic,format), valid_request(params.merge!(format: format)), valid_session
   end

   def process_oauth_request(access_grant, topic, params = {}, format = "json")
      oauth_post access_grant, url(topic,format), valid_request(params).merge!(format: format), valid_session
   end

   context "oauth authentication" do
      context "with write access to user data" do
         before(:each) do
            @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_data")
            @topic = FactoryGirl.create(:topic_with_feeds_and_fields, field_keys: ["key1", "key2", "key3"], user: @user, application: @access_grant.application)
         end
         context "multiple feeds" do
            context "with correct attributes" do
               before(:each) do
                  value_set1 = {}
                  value_set2 = {}
                  value_set3 = {}
                  ["key1", "key2", "key3"].each_with_index do |field, i|
                     value_set1.merge!(field => i.to_s)
                     value_set2.merge!(field => (i*2).to_s)
                     value_set3.merge!(field => (i*3).to_s)
                  end
                  @params = {
                     :feeds => [{
                        :at => '2013-12-12T21:00:15.000Z',
                        :tz => "Eastern Time (US & Canada)",
                        :data => value_set1
                     },
                     {
                        :at => '2013-12-13T21:00:15.000Z',
                        :tz => "Eastern Time (US & Canada)",
                        :data => value_set2
                     },
                     {
                        :at => '2013-12-14T21:00:15.000Z',
                        :tz => "Eastern Time (US & Canada)",
                        :data => value_set3
                     }
                  ]
                  }
               end

               it "returns a 201 status code" do
                  response = process_oauth_request(@access_grant, @topic, @params)
                  response.status.should == 201
               end

               it "returns the expected json" do
                  response = process_oauth_request(@access_grant,@topic, @params)
                  field_arr = @topic.fields.inject([]) do |arr, field|
                     arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
                  end
                  response.body.should be_json_eql("{\"fields\":[#{field_arr.join(',')}],\"feeds\":[{\"at\": \"2013-12-12T21:00:15.000Z\",\"data\": #{@params[:feeds][0][:data].to_json}, \"tz\": \"Eastern Time (US & Canada)\"}, {\"at\": \"2013-12-13T21:00:15.000Z\",\"data\": #{@params[:feeds][1][:data].to_json}, \"tz\": \"Eastern Time (US & Canada)\"}, {\"at\": \"2013-12-14T21:00:15.000Z\",\"data\": #{@params[:feeds][2][:data].to_json}, \"tz\": \"Eastern Time (US & Canada)\"}]}")
               end

               it "returns the expected xml" do
                  pending("xml response")                  
                  response = process_oauth_request(@access_grant, @topic, @params, "xml")
               end

            end

            context "file upload" do
               # it "accepts a csv file" do
               #    response = process_multipart_oauth_request(@access_grant,@topic, "#{RSpec.configuration.fixture_path}/files/feeds.csv")
               #    response.status.should == 201
               # end

               # it "accepts a zipped csv file" do
               #    response = process_multipart_oauth_request(@access_grant,@topic, "#{RSpec.configuration.fixture_path}/files/feeds.zip")
               #    response.status.should == 201
               # end
               # it "accepts a xls file" do
               #    response = process_multipart_oauth_request(@access_grant,@topic, "#{RSpec.configuration.fixture_path}/files/feeds.xls")
               #    response.status.should == 201
               # end
               # it "accepts a xlsx file" do
               #    response = process_multipart_oauth_request(@access_grant,@topic, "#{RSpec.configuration.fixture_path}/files/feeds.xlsx")
               #    response.status.should == 201
               # end
               # it "accepts a ods file" do
               #    response = process_multipart_oauth_request(@access_grant,@topic, "#{RSpec.configuration.fixture_path}/files/feeds.ods")
               #    response.status.should == 201
               # end              

            end            
         end

         context "a single feed" do

            context "with correct attributes" do
               before(:each) do
                  values = {}
                  ["key1", "key2", "key3"].each_with_index do |field, i|
                     values.merge!(field => i.to_s)
                  end
                  @params = {
                     :feed => {
                        :at => Time.new(2013,11,14,3,56,6, "-00:00").utc.to_f,#Time.new(2013,11,14,3,56,6, "-00:00").utc.to_f,
                        :data => values
                     }
                  }
               end
               it "returns a 201 status code" do
                  response = process_oauth_request(@access_grant,@topic, @params)
                  response.status.should == 201
               end

               it "returns the expected json" do
                  response = process_oauth_request(@access_grant,@topic, @params)

                  field_arr = @topic.fields.inject([]) do |arr, field|
                     arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
                  end
                  response.body.should be_json_eql("{\"at\": \"2013-11-14T03:56:06.000Z\",\"data\": #{@params[:feed][:data].to_json},\"fields\": [#{field_arr.join(",")}], \"tz\": \"UTC\"}")                  
               end

               context "on first commit of fields" do
                  it "creates new fields for the data that don't exist"
               end

               it "creates a new Feed" do
                   client = ENV['ELASTICSEARCH_URL'] ? ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL']) : ::Elasticsearch::Client.new
                  client.indices.refresh(:index => ELASTIC_INDEX_NAME)
                  before_count = @topic.feeds.count
                  process_oauth_request(@access_grant,@topic, @params)
                  client.indices.refresh(:index => ELASTIC_INDEX_NAME)
                  after_count = @topic.feeds.count
                  (after_count - before_count).should == 1
               end

               context "with a :tz attribute" do
                  before(:each) do
                     @params[:feed].merge!(:tz => "Eastern Time (US & Canada)")
                  end
                  it "returns the expected json" do
                     response = process_oauth_request(@access_grant,@topic, @params)
                     field_arr = @topic.fields.inject([]) do |arr, field|
                        arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
                     end
                     response.body.should be_json_eql("{\"at\": \"2013-11-14T03:56:06.000Z\",\"data\": #{@params[:feed][:data].to_json},\"fields\": [#{field_arr.join(",")}], \"tz\": \"Eastern Time (US & Canada)\"}")                     
                  end
               end

               context "but without the :at attribute" do
                  before(:each) do
                     @params[:feed].delete(:at)
                  end

                  it "is a success because it sets :at to the current time" do
                     response = process_oauth_request(@access_grant,@topic, @params)
                     response.status.should == 201
                  end
               end
               context "a feed from another application" do
                  before(:each) do
                     @application = FactoryGirl.create(:application)
                     @topic.application = @application
                     @topic.save
                  end

                  it "is successful" do
                     response = process_oauth_request(@access_grant,@topic, @params)
                     response.status.should == 201
                  end

                  it "creates the feed on the topic of the application" do
                     client = ENV['ELASTICSEARCH_URL'] ? ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL']) : ::Elasticsearch::Client.new
                     client.indices.refresh(:index => ELASTIC_INDEX_NAME)
                     before_count = @topic.feeds.count
                     process_oauth_request(@access_grant,@topic, @params)
                     client.indices.refresh(:index => ELASTIC_INDEX_NAME)
                     after_count = @topic.feeds.count
                     (after_count - before_count).should == 1
                  end                  
               end

               context "a feed from another user" do
                  before(:each) do
                     @client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
                     @another_user = Sensit::User.create(:name => "another_user", :email => "another_user@example.com", :password => "password", :password_confirmation => "password")
                     @topic = FactoryGirl.create(:topic_with_feeds, user: @another_user, application: @access_grant.application)
                  end
                  after(:each) do
                     @client.indices.flush(index: "another_user", refresh: true)
                  end                  
                  it "cannot create data on another user" do
                     expect{
                        response = process_oauth_request(@access_grant, @topic, @params)
                        response.status.should == 401
                     }.to raise_error(OAuth2::Error)
                  end
               end                
            end
         end        
      end

      context "with write access to only the applications data" do
         before(:each) do
            values = {}
            ["key1", "key2", "key3"].each_with_index do |field, i|
               values.merge!(field => i.to_s)
            end
            @application = FactoryGirl.create(:application)
            @params = {
               :feed => {
                  :at => Time.new(2013,11,14,3,56,6, "-00:00").utc.to_f,#Time.new(2013,11,14,3,56,6, "-00:00").utc.to_f,
                  :data => values
               }
            }

            @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_data")
            @topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
            @topic.save
         end
         it "cannot update data to another application" do
            expect{
               response = process_oauth_request(@access_grant, @topic, @params)
               response.status.should == 401
            }.to raise_error(OAuth2::Error)
         end
      end         
   end

end