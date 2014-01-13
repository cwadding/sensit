require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

module Sensit
    describe TopicsController do


      def valid_request(h = {})
        h.merge!({:use_route => :sensit_api, :format => "json", :api_version => 1})
      end
      # This should return the minimal set of attributes required to create a valid
      # Topic. As you add validations to Topic, be sure to
      # update the return value of this method accordingly.
      def valid_attributes
        { "name" => "my topic" }
      end

      # This should return the minimal set of values that should be in the session
      # in order to pass any filters (e.g. authentication) defined in
      # TopicsController. Be sure to keep this updated too.
      def valid_session(params = {})
        {}.merge!(params)
      end

      describe "GET index" do
        it "assigns all topics as @topics" do
          topic = Topic.create! valid_attributes
          get :index, valid_request, valid_session(user_id: @user.to_param)
          assigns(:topics).should eq([topic])
        end
      end

      describe "GET show" do
        it "assigns the requested topic as @topic" do
          topic = Topic.create! valid_attributes
          get :show, valid_request({:id => topic.to_param}), valid_session(user_id: @user.to_param)
          assigns(:topic).should eq(topic)
        end
      end

      describe "POST create" do
        describe "with valid params" do
          it "creates a new Topic" do
            expect {
              post :create, valid_request({:topic => valid_attributes}), valid_session(user_id: @user.to_param)
            }.to change(Topic, :count).by(1)
          end

          it "assigns a newly created topic as @topic" do
            post :create, valid_request({:topic => valid_attributes}), valid_session(user_id: @user.to_param)
            assigns(:topic).should be_a(Topic)
            assigns(:topic).should be_persisted
          end

          it "redirects to the created topic" do
            post :create, valid_request({:topic => valid_attributes}), valid_session(user_id: @user.to_param)
            response.should render_template("sensit/topics/show")
          end
        end

        describe "with invalid params" do
          it "assigns a newly created but unsaved topic as @topic" do
            # Trigger the behavior that occurs when invalid params are submitted
            Topic.any_instance.stub(:save).and_return(false)
            post :create, valid_request({:topic => { "name" => "invalid value" }}), valid_session(user_id: @user.to_param)
            assigns(:topic).should be_a_new(Topic)
          end

          it "re-renders the 'new' template" do
            # Trigger the behavior that occurs when invalid params are submitted
            Topic.any_instance.stub(:save).and_return(false)
            post :create, valid_request({:topic => { "name" => "invalid value" }}), valid_session(user_id: @user.to_param)
            response.status.should == 422
          end
        end
      end

      describe "PUT update" do
        describe "with valid params" do
          it "updates the requested topic" do
            topic = Topic.create! valid_attributes
            # Assuming there are no other topics in the database, this
            # specifies that the Topic created on the previous line
            # receives the :update_attributes message with whatever params are
            # submitted in the request.
            Topic.any_instance.should_receive(:update).with({ "name" => "1" })
            put :update, valid_request({:id => topic.to_param, :topic => { "name" => "1" }}), valid_session(user_id: @user.to_param)
          end

          it "assigns the requested topic as @topic" do
            topic = Topic.create! valid_attributes
            put :update, valid_request({:id => topic.to_param, :topic => { "name" => "1" }}), valid_session(user_id: @user.to_param)
            assigns(:topic).should eq(topic)
          end

          it "redirects to the topic" do
            topic = Topic.create! valid_attributes
            put :update, valid_request({:id => topic.to_param, :topic => { "name" => "1" }}), valid_session(user_id: @user.to_param)
            response.should render_template("sensit/topics/show")
          end
        end

        describe "with invalid params" do
          it "assigns the topic as @topic" do
            topic = Topic.create! valid_attributes
            # Trigger the behavior that occurs when invalid params are submitted
            Topic.any_instance.stub(:save).and_return(false)
            put :update, valid_request({:id => topic.to_param, :topic => { "name" => "invalid value" }}), valid_session(user_id: @user.to_param)
            assigns(:topic).should eq(topic)
          end

          it "re-renders the 'edit' template" do
            topic = Topic.create! valid_attributes
            # Trigger the behavior that occurs when invalid params are submitted
            Topic.any_instance.stub(:save).and_return(false)
            put :update, valid_request({:id => topic.to_param, :topic => { "name" => "invalid value" }}), valid_session(user_id: @user.to_param)
            response.status.should == 422
          end
        end
      end

      describe "DELETE destroy" do
        it "destroys the requested topic" do
          topic = Topic.create! valid_attributes
          expect {
            delete :destroy, valid_request({:id => topic.to_param}), valid_session(user_id: @user.to_param)
          }.to change(Topic, :count).by(-1)
        end

        it "redirects to the topics list" do
          topic = Topic.create! valid_attributes
          delete :destroy, valid_request({:id => topic.to_param}), valid_session(user_id: @user.to_param)
          response.status.should == 204
        end
      end

    end
end
