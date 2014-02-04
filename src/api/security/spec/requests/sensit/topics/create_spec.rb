require 'spec_helper'
describe "POST sensit/topics#create" do

   before(:each) do
      @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_data")
      @topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
   end

   def process_oauth_request(access_grant,params)
      post "/api/topics", valid_request(params), valid_session
   end

   context "without a unique name for an APIKey" do
      before(:each) do
         FactoryGirl.create(:topic, :name => "Existing Topic", application: @access_grant.application)
      end
      before(:each) do
         @params = {
            :topic => {
               :name => "Existing Topic"
            }
         }
      end
      # it "is an unprocessable entity" do
      #    status = process_oauth_request(@access_grant,@params)
      #    status.should == 422
      # end

      # it "returns the expected json" do
      #    process_oauth_request(@access_grant,@params)
      #    response.body.should be_json_eql("{\"errors\":{\"name\":[\"has already been taken\"]}}")
      # end
   end

   context "without a unique name attribute across api_keys" do
      before(:each) do
         FactoryGirl.create(:topic, :name => "Existing Topic", application: @access_grant.application)
      end
      before(:each) do
         @params = {
            :topic => {
               :name => "Existing Topic"
            }
         }
      end
      it "is a success" do
         status = process_oauth_request(@access_grant,@params)
         status.should == 200
      end

      it "creates a new Topic" do
          expect {
            process_oauth_request(@access_grant,@params)
          }.to change(Sensit::Topic, :count).by(1)
        end
   end

end