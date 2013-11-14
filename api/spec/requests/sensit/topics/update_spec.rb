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
         expect(response).to render_template(:show)
         response.body.should be_json_eql('{\"id\":1,"description": null,"feeds": [{"data": [{"key150": "Value150"}]}],"fields": [{"key": "key145","name": "Field145"}],"name": "New topic name"}')

      end

      it "updates the existing Topic" do
			process_request(@node, @params)
			updated_topic = Sensit::Node::Topic.find(@topic.id)
			updated_topic.name.should == "New topic name"
			updated_topic.description.should == "new description"
        end
   end
end