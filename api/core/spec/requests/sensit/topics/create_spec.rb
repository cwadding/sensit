require 'spec_helper'
describe "POST sensit/topics#create" do

   def url(format = "json")
      "/api/topics.#{format}"
   end

   def process_oauth_request(access_grant,params ={}, format = "json")
      oauth_post access_grant, url(format), valid_request(params), valid_session
   end

   def process_request(access_grant,params ={}, format = "json")
      post url(format), valid_request(params), valid_session
   end   

   context "with valid attributes" do
      before(:each) do
         @params = {
            :topic => {
               :name => "Test topic",
               :description => "A description of my topic"
            }
         }
      end
      context "oauth authentication" do
         context "with write access to the users data" do
            before(:each) do
               @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_data")
            end
            
            context "writing to own application" do
               it "returns a 200 status code" do
                  response = process_oauth_request(@access_grant,@params)
                  response.status.should == 201
               end

               it "returns the expected json" do
                  response = process_oauth_request(@access_grant,@params)
                  response.body.should be_json_eql('{"description": "A description of my topic","feeds": [],"name": "Test topic"}')
               end

               it "returns the expected xml" do
                  response = process_oauth_request(@access_grant, @params, "xml")
                  pending("xml response: #{response.body}")
               end

               it "creates a new Topic" do
                   expect {
                     response = process_oauth_request(@access_grant,@params)
                   }.to change(Sensit::Topic, :count).by(1)
               end

               context "with ttl" do
                  before(:each) do
                     @params[:topic].merge!({:ttl => 90.days.to_i})
                  end

                  it "returns the expected json" do
                     response = process_oauth_request(@access_grant,@params)
                     response.body.should be_json_eql('{"description": "A description of my topic","feeds": [],"name": "Test topic"}')
                  end

                  it "returns the expected xml" do
                     response = process_oauth_request(@access_grant, @params, "xml")
                     pending("xml response: #{response.body}")
                  end
               end

               context "without the name attribute" do
                  before(:each) do
                     @params[:topic].delete(:name)
                  end

                  it "is an unprocessable entity" do
                     expect{
                        response = process_oauth_request(@access_grant,@params)
                        response.status.should == 422
                     }.to raise_error(OAuth2::Error)
                  end

                  it "returns the expected json" do
                     expect{
                        response = process_oauth_request(@access_grant,@params)
                        response.body.should be_json_eql("{\"errors\":{\"name\":[\"can't be blank\"]}}")
                     }.to raise_error(OAuth2::Error)
                  end
               end
            end
            context "writing to another application" do
               before(:each) do
                  @application = FactoryGirl.create(:application)
                  @params[:topic].merge!({:application_id =>  @application.to_param})
               end

               it "creates a new Topic in the application" do
                   expect {
                     response = process_oauth_request(@access_grant,@params)
                   }.to change(@application.topics, :count).by(1)
               end
            end

            context "writing a topic owned by another user" do
               before(:each) do
                  @another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
                  @topic = FactoryGirl.create(:topic_with_feeds, user: @another_user, application: @access_grant.application)
               end
               it "cannot write data from another user" do
                  expect{
                     response = process_oauth_request(@access_grant, @params)
                     response.status.should == 401
                  }.to raise_error(OAuth2::Error)
               end
            end

         end
         context "with write access to only the applications data" do
            before(:each) do
               @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_application_data")
               @application = FactoryGirl.create(:application)
               @params[:topic].merge!({:application_id =>  @application.to_param})               
            end

            it "cannot write data to another application" do
               expect{
                  response = process_oauth_request(@access_grant, @params)
                  response.status.should == 401
                  @application.topics.count.should == 0                  
               }.to raise_error(OAuth2::Error)
            end

         end         
      end
      context "no authentication" do
         it "is unauthorized" do
            status = process_request(@params)
            status.should == 401
         end
      end
   end

end