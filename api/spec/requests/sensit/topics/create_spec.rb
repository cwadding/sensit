require 'spec_helper'
describe "POST sensit/topics#create" do
   # {
   #    "topic":{
   #       "name":"my_topic2",
   #       "fields":[
   #          {
   #             "0":{
   #                "name":"col3",
   #                "key":"c3",
   #                "unit":"mm",
   #                "datatype":"integer"
   #             },
   #             "1":{
   #                "name":"col5",
   #                "key":"c5",
   #                "unit":"filename",
   #                "datatype":"string"
   #             },
   #             "2":{
   #                "name":"col4",
   #                "key":"c4",
   #                "unit":"s",
   #                "datatype":"float"
   #             }
   #          }
   #       ]
   #    }
   # }

   before(:each) do
      @node = FactoryGirl.create(:node)
   end

   def process_request(node, params)
      post "/api/nodes/#{node.id}/topics", valid_request(params), valid_session
   end

   context "with correct attributes" do
      before(:all) do
         @params = {
            :topic => {
               :name => "Test topic",
               :description => "A description of my topic"
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
         response.body.should be_json_eql('{"description": null,"feeds": [],"fields": [],"name": "Test topic"}')
      end

      it "creates a new Topic" do
          expect {
            process_request(@node, @params)
          }.to change(Sensit::Node::Topic, :count).by(1)
        end
   end

   context "without the name attribute" do
      before(:all) do
         @params = {
            :topic => {
               :description => "A description of my topic"
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

   context "without a unique name within a node" do
      before(:each) do
         FactoryGirl.create(:topic, :name => "Existing Topic", :node => @node)
      end
      before(:all) do
         @params = {
            :topic => {
               :name => "Existing Topic"
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

   context "without a unique name attribute across nodes" do
      before(:each) do
         FactoryGirl.create(:topic, :name => "Existing Topic")
      end
      before(:all) do
         @params = {
            :topic => {
               :name => "Existing Topic"
            }
         }
      end
      it "is a success" do
         status = process_request(@node, @params)
         status.should == 200
      end

      it "creates a new Topic" do
          expect {
            process_request(@node, @params)
          }.to change(Sensit::Node::Topic, :count).by(1)
        end
   end

end