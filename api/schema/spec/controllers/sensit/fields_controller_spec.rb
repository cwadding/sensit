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
  describe FieldsController do

    # This should return the minimal set of attributes required to create a valid
    # ::Sensit::Topic::Field. As you add validations to ::Sensit::Topic::Field, be sure to
    # adjust the attributes here as well.
      def valid_request(h = {})
        h.merge!({:use_route => :sensit_api, :format => "json", :api_version => 1})
      end
      # This should return the minimal set of attributes required to create a valid
      # ::Sensit::Topic::Field. As you add validations to ::Sensit::Topic::Feed, be sure to
      # update the return value of this method accordingly.
      def valid_attributes
        { "key" => "hello", "name" => "world" }
      end

      def invalid_attributes
        { "key" => "hello" }
      end      

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # ::Sensit::Topic::FieldsController. Be sure to keep this updated too.
      def valid_session(params = {})
        {}.merge!(params)
      end

    describe "GET index" do
      it "assigns all fields as @fields" do
        topic = FactoryGirl.create(:topic, user: @user)
        field = ::Sensit::Topic::Field.create! valid_attributes.merge!(:topic_id => topic.id)
        get :index, valid_request(:topic_id => topic.to_param), valid_session(user_id: @user.to_param)
        assigns(:fields).to_a.should eq([field])
      end
    end

    describe "GET show" do
      it "assigns the requested field as @field" do
        field = ::Sensit::Topic::Field.create! valid_attributes
        get :show, valid_request({:id => field.to_param}), valid_session(user_id: @user.to_param)
        assigns(:field).should eq(field)
      end
    end

    describe "POST create" do
      before(:each) do
        Topic.any_instance.stub(:find).with(1).and_return(FactoryGirl.create(:topic, user: @user))
      end
      describe "with valid params" do
        it "creates a new ::Sensit::Topic::Field" do
          expect {
            post :create, valid_request({ "topic_id" => "1", :field => valid_attributes}), valid_session(user_id: @user.to_param)
          }.to change(::Sensit::Topic::Field, :count).by(1)
        end

        it "assigns a newly created field as @field" do
          post :create, valid_request({ "topic_id" => "1", :field => valid_attributes}), valid_session(user_id: @user.to_param)
          assigns(:field).should be_a(::Sensit::Topic::Field)
          assigns(:field).should be_persisted
        end

        it "redirects to the created field" do
          post :create, valid_request({ "topic_id" => "1", :field => valid_attributes}), valid_session(user_id: @user.to_param)
          response.should render_template("sensit/fields/show")
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved field as @field" do
          # Trigger the behavior that occurs when invalid params are submitted
          ::Sensit::Topic::Field.any_instance.stub(:save).and_return(false)
          post :create, valid_request({ "topic_id" => "1", :field => { "topic_id" => "1", :key => "asd"  }}), valid_session(user_id: @user.to_param)
          assigns(:field).should be_a_new(::Sensit::Topic::Field)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          ::Sensit::Topic::Field.any_instance.stub(:save).and_return(false)
          post :create, valid_request({ "topic_id" => "1", :field => { "topic_id" => "1", :key => "asd" }}), valid_session(user_id: @user.to_param)
          response.status.should == 422
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested field" do
          field = ::Sensit::Topic::Field.create! valid_attributes
          # Assuming there are no other fields_fields in the database, this
          # specifies that the ::Sensit::Topic::Field created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          ::Sensit::Topic::Field.any_instance.should_receive(:update).with({ "key" => "params" })
          put :update, valid_request({:id => field.to_param, :field => { "key" => "params" }}), valid_session(user_id: @user.to_param)
        end

        it "assigns the requested field as @field" do
          field = ::Sensit::Topic::Field.create! valid_attributes
          put :update, valid_request({:id => field.to_param, :field => { "key" => "params" }}), valid_session(user_id: @user.to_param)
          assigns(:field).should eq(field)
        end

        it "redirects to the field" do
          field = ::Sensit::Topic::Field.create! valid_attributes
          put :update, valid_request({:id => field.to_param, :field => { "key" => "params" }}), valid_session(user_id: @user.to_param)
          response.should render_template("sensit/fields/show")
        end
      end

      describe "with invalid params" do
        it "assigns the field as @field" do
          field = ::Sensit::Topic::Field.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ::Sensit::Topic::Field.any_instance.stub(:save).and_return(false)
          put :update, valid_request({:id => field.to_param, :field => { "key" => "params" }}), valid_session(user_id: @user.to_param)
          assigns(:field).should eq(field)
        end

        it "re-renders the 'edit' template" do
          field = ::Sensit::Topic::Field.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ::Sensit::Topic::Field.any_instance.stub(:save).and_return(false)
          put :update, valid_request({:id => field.to_param, :field => { "key" => "asd" }}), valid_session(user_id: @user.to_param)
          response.status.should == 422
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested field" do
        field = ::Sensit::Topic::Field.create! valid_attributes
        expect {
          delete :destroy, valid_request({:id => field.to_param}), valid_session(user_id: @user.to_param)
        }.to change(::Sensit::Topic::Field, :count).by(-1)
      end

      it "redirects to the fields_fields list" do
        field = ::Sensit::Topic::Field.create! valid_attributes
        delete :destroy, valid_request({:id => field.to_param}), valid_session(user_id: @user.to_param)
        response.status.should == 204
      end
    end

  end
end
