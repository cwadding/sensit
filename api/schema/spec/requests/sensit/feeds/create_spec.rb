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

   before(:each) do
      @topic = FactoryGirl.create(:topic_with_feeds_and_fields) 
   end

   def process_request(topic, params)
      post "/api/topics/#{topic.id}/feeds", valid_request(params), valid_session
   end

   context "multiple feeds"do
      context "with correct attributes" do
         it "returns a 200 status code" do
            fields = @topic.fields.map(&:key)
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
            status = process_request(@topic, params)
            status.should == 200
         end

         it "returns the expected json" do
           fields = @topic.fields.map(&:key)
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
            process_request(@topic, params)
            expect(response).to render_template(:index)
            
            field_arr = @topic.fields.inject([]) do |arr, field|
               arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
            end
            response.body.should be_json_eql("{\"fields\":[#{field_arr.join(',')}],\"feeds\":[{\"at\": 1386882015.0,\"data\": #{value_set1.to_json}, \"tz\": \"Eastern Time (US & Canada)\"}, {\"at\": 1386968415.0,\"data\": #{value_set2.to_json}, \"tz\": \"Eastern Time (US & Canada)\"}, {\"at\": 1387054815.0,\"data\": #{value_set3.to_json}, \"tz\": \"Eastern Time (US & Canada)\"}]}")
         end
      end
   end
   context "csv file" do
      before(:each) do
      @topic = FactoryGirl.create(:topic_with_feeds_and_fields, field_keys: ["key1", "key2", "key3"])
      end
      it "returns a 200 status code" do
         params = {
            :feeds => fixture_file_upload("#{RSpec.configuration.fixture_path}/files/feeds.csv", 'text/csv')
         }
         status = process_request(@topic, params)
         status.should == 200
      end
   end

   context "zipped csv file", :current => true do
      before(:each) do
      @topic = FactoryGirl.create(:topic_with_feeds_and_fields, field_keys: ["key1", "key2", "key3"])
      end
      it "returns a 200 status code" do
         params = {
            :feeds => fixture_file_upload("#{RSpec.configuration.fixture_path}/files/feeds.zip")
         }
         status = process_request(@topic, params)
         status.should == 200
      end
   end

   context "xls file" do
      before(:each) do
      @topic = FactoryGirl.create(:topic_with_feeds_and_fields, field_keys: ["key1", "key2", "key3"])
      end
      it "returns a 200 status code"
   end

   context "google spreadsheet file" do
      before(:each) do
      @topic = FactoryGirl.create(:topic_with_feeds_and_fields, field_keys: ["key1", "key2", "key3"])
      end
      it "returns a 200 status code"
   end

   context "OpenOffice file" do
      before(:each) do
      @topic = FactoryGirl.create(:topic_with_feeds_and_fields, field_keys: ["key1", "key2", "key3"])
      end
      it "returns a 200 status code"
   end

   context "LibreOffice" do
      before(:each) do
      @topic = FactoryGirl.create(:topic_with_feeds_and_fields, field_keys: ["key1", "key2", "key3"])
      end
      it "returns a 200 status code"
   end

   context "a single feed" do

      context "with correct attributes" do
         
         it "returns a 200 status code" do
            fields = @topic.fields.map(&:key)
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
            status = process_request(@topic, params)
            status.should == 200
         end

         it "returns the expected json" do
            fields = @topic.fields.map(&:key)
            values = {}
            fields.each_with_index do |field, i|
               values.merge!(field => i.to_s)
            end
            params = {
               :feed => {
                  :at => Time.now.utc.to_f,#Time.new(2013,11,14,3,56,6, "-00:00").utc.to_f,
                  :values => values
               }
            }
            process_request(@topic, params)
            expect(response).to render_template(:show)
            
            field_arr = @topic.fields.inject([]) do |arr, field|
               arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
            end
            response.body.should be_json_eql("{\"at\": #{params[:feed][:at]},\"data\": #{values.to_json},\"fields\": [#{field_arr.join(",")}], \"tz\": \"UTC\"}")
         end

         context "on first commit of fields" do
            it "creates new fields for the data that don't exist" do

            end
         end

         # it "creates a new Feed" do
         #     expect {
         #       process_request(@topic, @params)
         #     }.to change(Sensit::Topic::Feed, :count).by(1)
         #   end
      end

      context "without the :at attribute" do
         before(:all) do
            @params = {
               :feed => {
                  :values => [{"key1" => 'dsfds'}]
               }
            }
         end

         it "is an unprocessable entity" do
            status = process_request(@topic, @params)
            status.should == 422
         end

         it "returns the expected json" do
            process_request(@topic, @params)
            response.body.should be_json_eql("{\"errors\":{\"at\":[\"can't be blank\"]}}")
         end
      end

      context "with a :tz attribute" do

         it "returns the expected json" do
            fields = @topic.fields.map(&:key)
            values = {}
            fields.each_with_index do |field, i|
               values.merge!(field => i.to_s)
            end
            params = {
               :feed => {
                  :at => Time.now.utc.to_f,#Time.new(2013,11,14,3,56,6, "-00:00").utc.to_f,
                  :tz => "Eastern Time (US & Canada)",
                  :values => values
               }
            }
            process_request(@topic, params)
            expect(response).to render_template(:show)
            
            field_arr = @topic.fields.inject([]) do |arr, field|
               arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
            end
            response.body.should be_json_eql("{\"at\": #{params[:feed][:at]},\"data\": #{values.to_json},\"fields\": [#{field_arr.join(",")}], \"tz\": \"Eastern Time (US & Canada)\"}")
         end
      end   
   end

end