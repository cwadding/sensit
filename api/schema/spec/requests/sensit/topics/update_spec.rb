require 'spec_helper'
describe "PUT sensit/topics#update" do

   before(:each) do
      @topic = FactoryGirl.create(:topic_with_feeds_and_fields, :user => @user, application: @application)
   end

   def process_request(topic, params)
      oauth_put "/api/topics/#{topic.id}", valid_request(params), valid_session(:user_id => topic.user.to_param)
   end

   context "with updated attributes" do
      before(:each) do
         @params = {
            :topic => {
               :name => "New topic name",
               :description => "new description"
            }
         }
      end

      it "returns a 200 status code" do
         response = process_request(@topic, @params)
         response.status.should == 200
      end

      it "returns the expected json" do
         response = process_request(@topic, @params)
         feeds_arr = []

         @topic.feeds.each do |feed|
            data_arr = []
            feed.values.each do |key, value|
               data_arr << "\"#{key}\": #{value}"
            end
            feeds_arr << "{\"at\":#{feed.at.utc.to_f}, \"data\":{#{data_arr.join(',')}}}"
         end
         fields_arr = []
         @topic.fields.each do |field|
            fields_arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
         end
         response.body.should be_json_eql("{\"id\":1,\"description\": \"#{@params[:topic][:description]}\",\"feeds\": [#{feeds_arr.join(',')}],\"fields\": [#{fields_arr.join(',')}],\"name\": \"#{@params[:topic][:name]}\"}")

      end

      it "updates the existing Topic" do
			response = process_request(@topic, @params)
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
            response = process_request(@topic, @params)
            feeds_arr = []

            @topic.feeds.each do |feed|
               data_arr = []
               feed.values.each do |key, value|
                  data_arr << "\"#{key}\": #{value}"
               end
               feeds_arr << "{\"at\":#{feed.at.utc.to_f}, \"data\":{#{data_arr.join(',')}}}"
            end
            fields_arr = []
            @topic.fields.each do |field|
               fields_arr << "{\"key\": \"#{field.key}\",\"name\": \"New#{field.name}\"}"
            end
            response.body.should be_json_eql("{\"id\":1,\"description\": \"#{@params[:topic][:description]}\",\"feeds\": [#{feeds_arr.join(',')}],\"fields\": [#{fields_arr.join(',')}],\"name\": \"#{@params[:topic][:name]}\"}")

         end       
      end
   end
end