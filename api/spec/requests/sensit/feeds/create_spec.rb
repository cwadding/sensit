require 'spec_helper'
describe "POST sensit/feeds#create" do
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
   end

   def process_request(node, params)
      topic = @node.topics.first
      post "/api/nodes/#{node.id}/topics/#{topic.id}/feeds", valid_request(params), valid_session
   end

   context "with correct attributes" do
      before(:all) do
         @params = {
            :feed => {
               :at => Time.new(2013,11,14,3,56,6),
               :data => []
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
         response.body.should be_json_eql("{\"at\": \"#{@params[:at].to_s}\",\"data\": [],\"fields\": [{\"key\": \"key4\", \"name\": \"Field4\"}]}")
      end

      it "creates a new Feed" do
          expect {
            process_request(@node, @params)
          }.to change(Sensit::Node::Topic::Feed, :count).by(1)
        end
   end

   context "without the :at attribute" do
      before(:all) do
         @params = {
            :feed => {
               :data => [{"sdf" => 'dsfds'}]
            }
         }
      end

      it "is an unprocessable entity", :current => true do
         status = process_request(@node, @params)
         status.should == 422
      end

      it "returns the expected json" do
         process_request(@node, @params)
         response.body.should be_json_eql("{\"errors\":{\"at\":[\"can't be blank\"]}}")
      end
   end


end