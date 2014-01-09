require 'spec_helper'
describe "PUT sensit/topics#update" do

   before(:each) do
      @topic = FactoryGirl.create(:topic_with_feeds)
   end

   def process_request(topic, params)
      put "/api/topics/#{topic.id}", valid_request(params), valid_session
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
         status = process_request(@topic, @params)
         status.should == 200
      end

      it "returns the expected json" do
         process_request(@topic, @params)
         feeds_arr = []

         @topic.feeds.each do |feed|
            data_arr = []
            feed.values.each do |key, value|
               data_arr << "\"#{key}\": #{value}"
            end
            feeds_arr << "{\"at\":\"#{feed.at.utc.iso8601}\", \"data\":{#{data_arr.join(',')}}}"
         end
         response.body.should be_json_eql("{\"id\":1,\"description\": \"#{@params[:topic][:description]}\",\"feeds\": [#{feeds_arr.join(',')}],\"name\": \"#{@params[:topic][:name]}\"}")

      end

      it "updates the existing Topic" do
			process_request(@topic, @params)
			updated_topic = Sensit::Topic.find(@topic.id)
			updated_topic.name.should == "New topic name"
			updated_topic.description.should == "new description"
        end
   end
end