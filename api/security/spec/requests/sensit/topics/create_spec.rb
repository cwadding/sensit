require 'spec_helper'
describe "POST sensit/topics#create" do

   before(:each) do
      @topic = FactoryGirl.create(:topic, user: @user)
   end

   def process_request(params)
      post "/api/topics", valid_request(params), valid_session
   end

   context "without a unique name for an APIKey" do
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
      # it "is an unprocessable entity" do
      #    status = process_request(@params)
      #    status.should == 422
      # end

      # it "returns the expected json" do
      #    process_request(@params)
      #    response.body.should be_json_eql("{\"errors\":{\"name\":[\"has already been taken\"]}}")
      # end
   end

   context "without a unique name attribute across api_keys" do
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
         status = process_request(@params)
         status.should == 200
      end

      it "creates a new Topic" do
          expect {
            process_request(@params)
          }.to change(Sensit::Topic, :count).by(1)
        end
   end

end