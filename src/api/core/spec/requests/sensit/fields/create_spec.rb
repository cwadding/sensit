require 'spec_helper'
describe "POST sensit/fields#create" do

	before(:each) do
      @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_data")
		@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
		@field = @topic.fields.first		
	end

   def process_oauth_request(access_grant,topic, params)
      oauth_post access_grant, "/api/topics/#{topic.to_param}/fields", valid_request(params), valid_session(:user_id => topic.user.to_param)
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
         response = process_oauth_request(@access_grant,@topic, @params)
         response.status.should == 201
      end

      it "returns the expected json" do
         response = process_oauth_request(@access_grant,@topic, @params)
         response.body.should be_json_eql("{\"key\":\"my_field\",\"name\":\"My Field\"}")
      end

      it "creates a new Field" do
          expect {
            response = process_oauth_request(@access_grant,@topic, @params)
          }.to change(Sensit::Topic::Field, :count).by(1)
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
         expect{
            response = process_oauth_request(@access_grant,@topic, @params)
            response.status.should == 422            
         }.to raise_error(OAuth2::Error)

      end

      it "returns the expected json" do
         expect{
            response = process_oauth_request(@access_grant,@topic, @params)
            response.body.should be_json_eql("{\"errors\":{\"name\":[\"can't be blank\"]}}")
         }.to raise_error(OAuth2::Error)
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
         expect{
            response = process_oauth_request(@access_grant,@topic, @params)
            response.status.should == 422
         }.to raise_error(OAuth2::Error)
      end

      it "returns the expected json" do
         expect{
            response = process_oauth_request(@access_grant,@topic, @params)
            response.body.should be_json_eql("{\"errors\":{\"key\":[\"can't be blank\"]}}")
         }.to raise_error(OAuth2::Error)
      end
   end   

   context "without a unique name within a topic" do
      before(:each) do
         FactoryGirl.create(:field, :name => "Existing Field", :key => "my_key", :topic => @topic)
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
         expect{
            response = process_oauth_request(@access_grant,@topic, @params)
            response.status.should == 422
         }.to raise_error(OAuth2::Error)
      end

      it "returns the expected json" do
         expect{
         response = process_oauth_request(@access_grant,@topic, @params)
         response.body.should be_json_eql("{\"errors\":{\"name\":[\"has already been taken\"]}}")
         }.to raise_error(OAuth2::Error)
      end
   end

   context "without a unique key within a topic" do
      before(:each) do
         FactoryGirl.create(:field, :name => "Field Name", :key => "existing_key", :topic => @topic)
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
         expect{
            response = process_oauth_request(@access_grant,@topic, @params)
            response.status.should == 422
         }.to raise_error(OAuth2::Error)         
      end

      it "returns the expected json" do
         expect{
            response = process_oauth_request(@access_grant,@topic, @params)
            response.body.should be_json_eql("{\"errors\":{\"key\":[\"has already been taken\"]}}")
         }.to raise_error(OAuth2::Error)         
      end
   end


   context "with a non-unique name between topics" do
      before(:each) do
         new_topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
         FactoryGirl.create(:field, :name => "Existing Field", :key => "my_key", topic: new_topic)
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
         response = process_oauth_request(@access_grant,@topic, @params)
         response.status.should == 201
      end

      it "creates a new Field" do
          expect {
            response = process_oauth_request(@access_grant,@topic, @params)
          }.to change(Sensit::Topic::Field, :count).by(1)
        end

      it "returns the expected json" do
         response = process_oauth_request(@access_grant,@topic, @params)
         response.body.should be_json_eql('{"key": "a_new_key","name": "Existing Field"}')
      end
   end
end