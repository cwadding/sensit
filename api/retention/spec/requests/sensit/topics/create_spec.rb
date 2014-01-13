require 'spec_helper'
describe "POST sensit/topics#create" do

   before(:each) do
      @topic = FactoryGirl.create(:topic, user: @user)
   end

   def process_request(params)
      post "/api/topics", valid_request(params), valid_session
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
      
      it "returns a 200 status code" do
         status = process_request(@params)
         status.should == 200
      end

      it "returns the expected json" do
         process_request(@params)
         expect(response).to render_template(:show)
         response.body.should be_json_eql('{"description": "A description of my topic","feeds": [],"name": "Test topic"}')
      end

      it "creates a new Topic" do
          expect {
            process_request(@params)
          }.to change(Sensit::Topic, :count).by(1)
      end
   end

   context "without the ttl attribute" do
      before(:all) do
         @params = {
            :topic => {
               :name => "Test topic",
               :description => "A description of my topic"
            }
         }
      end

      it "sets to the default ttl" do
         status = process_request(@params)
         status.should == 422
      end
   end

end