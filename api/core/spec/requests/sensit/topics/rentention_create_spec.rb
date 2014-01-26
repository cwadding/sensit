require 'spec_helper'
describe "POST sensit/topics#create" do

   before(:each) do
      @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_data")
      @topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
   end

   def process_oauth_request(access_grant,params)
      oauth_post access_grant, "/api/topics", valid_request(params), valid_session
   end

   context "with correct attributes" do
      before(:each) do
         @params = {
            :topic => {
               :name => "Test topic",
               :description => "A description of my topic",
               :ttl => 90.days.to_i
            }
         }
      end
      
      it "returns a 201 status code" do
         response = process_oauth_request(@access_grant,@params)
         response.status.should == 201
      end

      it "returns the expected json" do
         response = process_oauth_request(@access_grant,@params)
         response.body.should be_json_eql('{"description": "A description of my topic","feeds": [],"name": "Test topic"}')
      end

      it "creates a new Topic" do
          expect {
            response = process_oauth_request(@access_grant,@params)
          }.to change(Sensit::Topic, :count).by(1)
      end
   end

end