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
         response.body.should be_json_eql("{\"id\":1,\"name\":\"Test topic\",\"description\":\"A description of my topic\",\"topics\":[]}")
      end

      it "updates the existing Topic" do
			process_request(@node, @params)
			updated_topic = Sensit::Node::Topic.find(@topic.id)
			expect(updated_topic.name).to == "New topic name"
			expect(updated_topic.description).to == "new description"
        end
   end
end