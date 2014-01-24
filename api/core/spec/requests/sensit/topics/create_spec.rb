require 'spec_helper'
describe "POST sensit/topics#create" do

   before(:each) do
      @topic = FactoryGirl.create(:topic, user: @user, application: @application)
   end

   def process_request(params)
      oauth_post "/api/topics", valid_request(params), valid_session
   end

   context "with correct attributes" do
      before(:each) do
         @params = {
            :topic => {
               :name => "Test topic",
               :description => "A description of my topic"
            }
         }
      end
      
      it "returns a 200 status code" do
         response = process_request(@params)
         response.status.should == 201
      end

      it "returns the expected json" do
         response = process_request(@params)
         response.body.should be_json_eql('{"description": "A description of my topic","feeds": [],"name": "Test topic"}')
      end

      it "creates a new Topic" do
          expect {
            response = process_request(@params)
          }.to change(Sensit::Topic, :count).by(1)
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
         expect{
            response = process_request(@params)
            response.status.should == 422
         }.to raise_error(OAuth2::Error)

      end

      it "returns the expected json" do
         expect{
            response = process_request(@params)
            response.body.should be_json_eql("{\"errors\":{\"name\":[\"can't be blank\"]}}")
         }.to raise_error(OAuth2::Error)
      end
   end

end