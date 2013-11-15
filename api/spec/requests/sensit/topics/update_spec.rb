require 'spec_helper'
describe "PUT sensit/topics#update" do

   before(:each) do
      @node = FactoryGirl.create(:complete_node)
      @topic = @node.topics.first
   end

   def process_request(node, params)
   	  topic = node.topics.first
      put "/api/nodes/#{node.id}/topics/#{topic.id}", valid_request(params), valid_session
   end

   context "with updated attributes" do
      before(:all) do
         @params = {
            :topic => {
               :name => "New topic name",
               :description => "new description"
            }
         }
      end

      it "returns a 200 status code" do
         status = process_request(@node, @params)
         status.should == 200
      end

      it "returns the expected json" do
         process_request(@node, @params)
         topic = @node.topics.first
         # feeds_arr = []
         # topic.feeds.each do |feed|

         # end
         data_arr = []
         feed = topic.feeds.first
         feed.data_rows.each do |datum|
            data_arr << "{\"#{datum.key}\": \"#{datum.value}\"}"
         end
         fields_arr = []
         topic.fields.each do |field|
            fields_arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
         end         
         expect(response).to render_template(:show)
         response.body.should be_json_eql("{\"id\":1,\"description\": \"new description\",\"feeds\": [{\"data\": [#{data_arr.join(',')}]}],\"fields\": [#{fields_arr.join(',')}],\"name\": \"New topic name\"}")

      end

      it "updates the existing Topic" do
			process_request(@node, @params)
			updated_topic = Sensit::Node::Topic.find(@topic.id)
			updated_topic.name.should == "New topic name"
			updated_topic.description.should == "new description"
        end
   end
end