require 'spec_helper'
describe "POST sensit/feeds#create", :current => true  do
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
      @node = FactoryGirl.create(:complete_node) 
      @topic = @node.topics.first
   end

   def process_request(node, params)
      topic = @node.topics.first
      post "/api/nodes/#{node.id}/topics/#{topic.id}/feeds", valid_request(params), valid_session
   end

   context "with correct attributes" do
      
      it "returns a 200 status code", :current => true do
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
         status = process_request(@node, params)
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
         process_request(@node, params)
         expect(response).to render_template(:show)
         
         field_arr = @topic.fields.inject([]) do |arr, field|
            arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
         end

         response.body.should be_json_eql("{\"at\": #{params[:feed][:at]},\"data\": #{values.to_json},\"fields\": [#{field_arr.join(",")}]}")
      end

      # it "creates a new Feed" do
      #     expect {
      #       process_request(@node, @params)
      #     }.to change(Sensit::Node::Topic::Feed, :count).by(1)
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
         status = process_request(@node, @params)
         status.should == 422
      end

      it "returns the expected json" do
         process_request(@node, @params)
         response.body.should be_json_eql("{\"errors\":{\"at\":[\"can't be blank\"]}}")
      end
   end


end