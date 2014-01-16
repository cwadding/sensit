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
  describe SubscriptionsController do

    before(:each) do
      @topic = Topic.create(:name => "MyTopic", user: @user)
    end

    def valid_request(h = {})
      h.merge!({:use_route => :sensit_api, :format => "json", :api_version => 1})
    end
    # This should return the minimal set of attributes required to create a valid
    # ::Sensit::Topic::Feed. As you add validations to ::Sensit::Topic::Feed, be sure to
    # update the return value of this method accordingly.
    def valid_attributes
      { :name => "MyString", :host => "127.0.0.1"}
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # ::Sensit::Topic::FeedsController. Be sure to keep this updated too.
    def valid_session(params = {})
      {}.merge!(params)
    end


    describe "GET index" do
      it "assigns all subscriptions as @subscriptions" do
        subscription = FactoryGirl.create(:subscription, :topic => @topic)
        get :index, valid_request({:topic_id => @topic.to_param}), valid_session(user_id: @user.to_param)
        assigns(:subscriptions).to_a.should eq([subscription])
      end
    end

    describe "GET show" do
      it "assigns the requested subscription as @subscription" do
        subscription = FactoryGirl.create(:subscription, :topic => @topic)
        get :show, valid_request({:id => subscription.to_param, :topic_id => @topic.to_param}), valid_session(user_id: @user.to_param)
        assigns(:subscription).should eq(subscription)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Subscription" do
          expect {
            post :create, valid_request({:topic_id => @topic.to_param, :subscription => valid_attributes}), valid_session(user_id: @user.to_param)
          }.to change(Sensit::Topic::Subscription, :count).by(1)
        end

        it "assigns a newly created subscription as @subscription" do
          post :create, valid_request({:topic_id => @topic.to_param, :subscription => valid_attributes}), valid_session(user_id: @user.to_param)
          assigns(:subscription).should be_a(Sensit::Topic::Subscription)
          assigns(:subscription).should be_persisted
        end

        it "redirects to the created subscription" do
          post :create, valid_request({:topic_id => @topic.to_param, :subscription => valid_attributes}), valid_session(user_id: @user.to_param)
          response.should render_template("sensit/subscriptions/show")
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved subscription as @subscription" do
          # Trigger the behavior that occurs when invalid params are submitted
          Sensit::Topic::Subscription.any_instance.stub(:save).and_return(false)
          post :create, valid_request({:topic_id => @topic.to_param, :subscription => { "name" => "invalid value" }}), valid_session(user_id: @user.to_param)
          assigns(:subscription).should be_a_new(Sensit::Topic::Subscription)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Sensit::Topic::Subscription.any_instance.stub(:save).and_return(false)
          post :create, valid_request({:topic_id => @topic.to_param, :subscription => { "name" => "invalid value" }}), valid_session(user_id: @user.to_param)
          response.status.should == 422
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested subscription" do
          subscription = FactoryGirl.create(:subscription, :topic => @topic)
          # Assuming there are no other subscriptions in the database, this
          # specifies that the Subscription created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Sensit::Topic::Subscription.any_instance.should_receive(:update).with({ "name" => "MyString" })
          put :update, valid_request({:id => subscription.to_param, :topic_id => @topic.to_param, :subscription => { "name" => "MyString" }}), valid_session(user_id: @user.to_param)
        end

        it "assigns the requested subscription as @subscription" do
          subscription = FactoryGirl.create(:subscription, :topic => @topic)
          put :update, valid_request({:id => subscription.to_param, :topic_id => @topic.to_param, :subscription => valid_attributes}), valid_session(user_id: @user.to_param)
          assigns(:subscription).should eq(subscription)
        end

        it "redirects to the subscription" do
          subscription = FactoryGirl.create(:subscription, :topic => @topic)
          put :update, valid_request({:id => subscription.to_param, :topic_id => @topic.to_param, :subscription => valid_attributes}), valid_session(user_id: @user.to_param)
          response.should render_template("sensit/subscriptions/show")
        end
      end

      describe "with invalid params" do
        it "assigns the subscription as @subscription" do
          subscription = FactoryGirl.create(:subscription, :topic => @topic)
          # Trigger the behavior that occurs when invalid params are submitted
          Sensit::Topic::Subscription.any_instance.stub(:save).and_return(false)
          put :update, valid_request({:id => subscription.to_param, :topic_id => @topic.to_param, :subscription => { "name" => "invalid value" }}), valid_session(user_id: @user.to_param)
          assigns(:subscription).should eq(subscription)
        end

        it "re-renders the 'edit' template" do
          subscription = FactoryGirl.create(:subscription, :topic => @topic)
          # Trigger the behavior that occurs when invalid params are submitted
          Sensit::Topic::Subscription.any_instance.stub(:save).and_return(false)
          put :update, valid_request({:id => subscription.to_param, :topic_id => @topic.to_param, :subscription => { "name" => "invalid value" }}), valid_session(user_id: @user.to_param)
          response.status.should == 422
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested subscription" do
        subscription = FactoryGirl.create(:subscription, :topic => @topic)
        expect {
          delete :destroy, valid_request({:id => subscription.to_param, :topic_id => @topic.to_param}), valid_session(user_id: @user.to_param)
        }.to change(Sensit::Topic::Subscription, :count).by(-1)
      end

      it "redirects to the subscriptions list" do
        subscription = FactoryGirl.create(:subscription, :topic => @topic)
        delete :destroy, valid_request({:id => subscription.to_param, :topic_id => @topic.to_param}), valid_session(user_id: @user.to_param)
        response.status.should == 204
      end
    end

  end
end
