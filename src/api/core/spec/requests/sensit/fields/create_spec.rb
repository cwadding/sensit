require 'spec_helper'
describe "POST sensit/fields#create" do

   def url(topic, format = "json")
      "/api/topics/#{topic.to_param}/fields.#{format}"
   end

   def process_oauth_request(access_grant,topic, params, format = "json")
      oauth_post access_grant, url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
   end

   def process_request(topic, params, format = "json")
      post url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
   end

   context "with valid attributes" do
      before(:each) do
         @params = {
            :field => {
               :name => "My Field",
               :key => "my_field"
            }
         }
      end
      context "oauth authentication" do
         context "with write access to the users data" do
            before(:each) do
               @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_data")
            end
            context "creating fields for the current application and user" do
               before(:each) do
                  @topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
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
               context "without the name attribute" do
                  before(:each) do
                     @params[:field].delete(:name)
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

               context "without the key attribute" do
                  before(:each) do
                     @params[:field].delete(:key)
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
                     FactoryGirl.create(:field, :name => @params[:field][:name], :key => "my_key", :topic => @topic)
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
                     FactoryGirl.create(:field, :name => "Field Name", :key => @params[:field][:key], :topic => @topic)
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
                     FactoryGirl.create(:field, :name => @params[:field][:name], :key => "my_key", topic: new_topic)
                  end
                  it "is a success" do
                     response = process_oauth_request(@access_grant,@topic, @params)
                     response.status.should == 201
                  end
               end
            end
            context "creating a field for another application" do
               before(:each) do
                  @application = FactoryGirl.create(:application)
                  @topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
               end

               it "returns the expected json" do
                  response = process_oauth_request(@access_grant,@topic, @params)
                  response.status.should == 201
                  response.body.should be_json_eql("{\"key\":\"my_field\",\"name\":\"My Field\"}")
               end
            end
            context "creating a field owned by another user" do
               before(:each) do
                  another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
                  @topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
               end
               it "cannot read data from another user" do
                  expect{
                     response = process_oauth_request(@access_grant, @topic, @params)
                     response.status.should == 401
                  }.to raise_error(OAuth2::Error)
               end
            end
         end
         context "with write access to only the applications data" do
            before(:each) do
               @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_data")
               @application = FactoryGirl.create(:application)
               @topic = FactoryGirl.create(:topic, user: @user, application: @application)
            end
            it "cannot update data to another application" do
               expect{
                  response = process_oauth_request(@access_grant, @topic, @params)
                  response.status.should == 401
               }.to raise_error(OAuth2::Error)
            end
         end
      end
      context "no authentication" do
         before(:each) do
            @topic = FactoryGirl.create(:topic, user: @user, application: nil)
         end
         it "is unauthorized" do
            status = process_request(@topic, @params)
            status.should == 401
         end
      end         
   end
end