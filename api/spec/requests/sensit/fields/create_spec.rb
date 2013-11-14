require 'spec_helper'
describe "POST sensit/fields#create" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
      @topic = @node.topics.first
		@field = @topic.fields.first		
	end

   def process_request(node, params)
		topic = @node.topics.first
      post "/api/nodes/#{node.id}/topics/#{topic.id}/fields", valid_request(params), valid_session
   end

   context "with correct attributes" do
      before(:all) do
         @params = {
            :field => {
               :name => "My Field",
               :key => "my_field"
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
         response.body.should be_json_eql("{\"key\":\"my_field\",\"name\":\"Test topic\",\"description\":\"A description of my topic\",\"topics\":[]}")
      end

      it "creates a new Field" do
          expect {
            process_request(@node, @params)
          }.to change(Sensit::Node::Topic::Field, :count).by(1)
        end
   end

   context "without the name attribute" do
      before(:all) do
         @params = {
            :field => {
               :key => "my_key"
            }
         }
      end

      it "is an unprocessable entity" do
         status = process_request(@node, @params)
         status.should == 422
      end

      it "returns the expected json" do
         process_request(@node, @params)
         response.body.should be_json_eql("{\"errors\":{\"name\":[\"can't be blank\"]}}")
      end
   end

   context "without a key attribute" do
      before(:all) do
         @params = {
            :field => {
               :name => "my name"
            }
         }
      end

      it "is an unprocessable entity" do
         status = process_request(@node, @params)
         status.should == 422
      end

      it "returns the expected json" do
         process_request(@node, @params)
         response.body.should be_json_eql("{\"errors\":{\"key\":[\"can't be blank\"]}}")
      end
   end   

   context "without a unique name within a topic" do
      before(:each) do
         FactoryGirl.create(:field, :name => "Existing Field", :key => "my_key", :topic => @node.topics.first)
      end
      before(:all) do
         @params = {
            :field => {
               :name => "Existing Field",
               :key => "a_new_key"
            }
         }
      end
      it "is an unprocessable entity" do
         status = process_request(@node, @params)
         status.should == 422
      end

      it "returns the expected json" do
         process_request(@node, @params)
         response.body.should be_json_eql("{\"errors\":{\"name\":[\"has already been taken\"]}}")
      end
   end

   context "without a unique key within a topic" do
      before(:each) do
         FactoryGirl.create(:field, :name => "Field Name", :key => "existing_key", :topic => @node.topics.first)
      end
      before(:all) do
         @params = {
            :field => {
               :name => "New Field",
               :key => "existing_key"
            }
         }
      end
      it "is an unprocessable entity" do
         status = process_request(@node, @params)
         status.should == 422
      end

      it "returns the expected json" do
         process_request(@node, @params)
         response.body.should be_json_eql("{\"errors\":{\"key\":[\"has already been taken\"]}}")
      end
   end
   context "without a unique name within a topic" do
      before(:each) do
         FactoryGirl.create(:field, :name => "Existing Field", :key => "my_key")
      end
      before(:all) do
         @params = {
            :field => {
               :name => "Existing Field",
               :key => "a_new_key"
            }
         }
      end
      it "is a success" do
         status = process_request(@node, @params)
         status.should == 200
      end

      it "creates a new Field" do
          expect {
            process_request(@node, @params)
          }.to change(Sensit::Node::Topic::Field, :count).by(1)
        end

      it "returns the expected json" do
         process_request(@node, @params)
         response.body.should be_json_eql("{\"errors\":{\"name\":[\"has already been taken\"]}}")
      end
   end

end