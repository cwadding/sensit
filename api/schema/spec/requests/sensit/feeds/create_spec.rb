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