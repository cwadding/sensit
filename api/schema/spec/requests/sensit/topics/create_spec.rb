require 'spec_helper'
describe "POST sensit/topics#create" do

   before(:each) do
      @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_data")
      @topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
   end

   def process_oauth_request(access_grant,user, params)
      oauth_post access_grant, "/api/topics", valid_request(params), valid_session(user_id: user.to_param)
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
         response = process_oauth_request(@access_grant,@user, @params)
         response.status.should == 201
      end

      it "returns the expected json" do
         response = process_oauth_request(@access_grant,@user, @params)
         response.body.should be_json_eql('{"description": "A description of my topic","feeds": [],"fields": [],"name": "Test topic"}')
      end

      it "creates a new Topic" do
          expect {
            response = process_oauth_request(@access_grant,@user, @params)
          }.to change(Sensit::Topic, :count).by(1)
      end

      context "with fields" do
         before(:each) do
            @params[:topic].merge!({:fields => [{name: "NewField1", key: "new_field_1"}, {name: "NewField2", key: "new_field_2"}]})
         end
         it "returns the expected json" do
            response = process_oauth_request(@access_grant,@user, @params)
            response.body.should be_json_eql("{\"description\": \"A description of my topic\",\"feeds\": [],\"fields\": [{\"name\":\"NewField1\",\"key\":\"new_field_1\"}, {\"name\":\"NewField2\",\"key\":\"new_field_2\"}],\"name\": \"Test topic\"}")
         end

         it "creates two new fields on the topic" do
             expect {
               response = process_oauth_request(@access_grant,@user, @params)
             }.to change(Sensit::Topic::Field, :count).by(2)
         end         
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
            response = process_oauth_request(@access_grant,@user, @params)
            response.status.should == 422
         }.to raise_error(OAuth2::Error)
      end

      it "returns the expected json" do
         expect{
            response = process_oauth_request(@access_grant,@user, @params)
            response.body.should be_json_eql("{\"errors\":{\"name\":[\"can't be blank\"]}}")
         }.to raise_error(OAuth2::Error)
      end
   end

end