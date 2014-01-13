require 'spec_helper'
describe "POST sensit/fields#create" do

	before(:each) do
		@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user)
		@field = @topic.fields.first		
	end

   def process_request(topic, params)
      post "/api/topics/#{topic.to_param}/fields", valid_request(params), valid_session(:user_id => topic.user.to_param)
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
         status = process_request(@topic, @params)
         status.should == 201
      end

      it "returns the expected json" do
         process_request(@topic, @params)
         expect(response).to render_template(:show)
         response.body.should be_json_eql("{\"key\":\"my_field\",\"name\":\"My Field\"}")
      end

      it "creates a new Field" do
          expect {
            process_request(@topic, @params)
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
         status = process_request(@topic, @params)
         status.should == 422
      end

      it "returns the expected json" do
         process_request(@topic, @params)
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
         status = process_request(@topic, @params)
         status.should == 422
      end

      it "returns the expected json" do
         process_request(@topic, @params)
         response.body.should be_json_eql("{\"errors\":{\"key\":[\"can't be blank\"]}}")
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
         status = process_request(@topic, @params)
         status.should == 422
      end

      it "returns the expected json" do
         process_request(@topic, @params)
         response.body.should be_json_eql("{\"errors\":{\"name\":[\"has already been taken\"]}}")
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
         status = process_request(@topic, @params)
         status.should == 422
      end

      it "returns the expected json" do
         process_request(@topic, @params)
         response.body.should be_json_eql("{\"errors\":{\"key\":[\"has already been taken\"]}}")
      end
   end


   context "with a non-unique name between topics" do
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
         status = process_request(@topic, @params)
         status.should == 201
      end

      it "creates a new Field" do
          expect {
            process_request(@topic, @params)
          }.to change(Sensit::Topic::Field, :count).by(1)
        end

      it "returns the expected json" do
         process_request(@topic, @params)
         response.body.should be_json_eql('{"key": "a_new_key","name": "Existing Field"}')
      end
   end
end