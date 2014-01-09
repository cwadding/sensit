require 'spec_helper'
describe "POST sensit/topics#create" do

   before(:each) do
      @topic = FactoryGirl.create(:topic)
   end

   def process_request(params)
      post "/api/topics", valid_request(params), valid_session
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
         status = process_request(@params)
         status.should == 201
      end

      it "returns the expected json" do
         process_request(@params)
         expect(response).to render_template(:show)
         response.body.should be_json_eql('{"description": "A description of my topic","feeds": [],"fields": [],"name": "Test topic"}')
      end

      it "creates a new Topic" do
          expect {
            process_request(@params)
          }.to change(Sensit::Topic, :count).by(1)
      end

      context "with fields" do
         before(:each) do
            @params[:topic].merge!({:fields => [{name: "NewField1", key: "new_field_1"}, {name: "NewField2", key: "new_field_2"}]})
         end
         it "returns the expected json" do
            process_request(@params)
            expect(response).to render_template(:show)
            response.body.should be_json_eql("{\"description\": \"A description of my topic\",\"feeds\": [],\"fields\": [{\"name\":\"NewField1\",\"key\":\"new_field_1\"}, {\"name\":\"NewField2\",\"key\":\"new_field_2\"}],\"name\": \"Test topic\"}")
         end

         it "creates two new fields on the topic" do
             expect {
               process_request(@params)
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
         status = process_request(@params)
         status.should == 422
      end

      it "returns the expected json" do
         process_request(@params)
         response.body.should be_json_eql("{\"errors\":{\"name\":[\"can't be blank\"]}}")
      end
   end

end