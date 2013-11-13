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
  describe DataController do

      def valid_request(h = {})
        {:use_route => :sensit_api, :format => "json", :api_version => 1}.merge!(h)
      end
      # This should return the minimal set of attributes required to create a valid
      # ::Sensit::Node::Topic::Feed. As you add validations to ::Sensit::Node::Topic::Feed, be sure to
      # update the return value of this method accordingly.
      def valid_attributes
        { key: "my_key", value: "123"}
      end

      # This should return the minimal set of values that should be in the session
      # in order to pass any filters (e.g. authentication) defined in
      # ::Sensit::Node::Topic::FeedsController. Be sure to keep this updated too.
      def valid_session
        {}
      end

    describe "GET index" do
      it "assigns all data as @data" do
        datum = ::Sensit::Node::Topic::Feed::DataRow.create! valid_attributes
        get :index, valid_request, valid_session
        assigns(:data).should eq([datum])
      end
    end

    describe "GET show" do
      it "assigns the requested data as @data" do
        datum = ::Sensit::Node::Topic::Feed::DataRow.create! valid_attributes
        get :show, valid_request({:id => datum.to_param}), valid_session
        assigns(:data).should eq(datum)
      end
    end

    describe "POST create" do
      before(:each) do
        Node::Topic::Feed.any_instance.stub(:find).with(1).and_return(FactoryGirl.create(:feed))
      end
      describe "with valid params" do
        it "creates a new Node::Topic::Feed::DataRow" do
          expect {
            post :create, valid_request({feed_id:1, :data => valid_attributes}), valid_session
          }.to change(::Sensit::Node::Topic::Feed::DataRow, :count).by(1)
        end

        it "assigns a newly created data as @data" do
          post :create, valid_request({feed_id:1, :data => valid_attributes}), valid_session
          assigns(:data).should be_a(::Sensit::Node::Topic::Feed::DataRow)
          assigns(:data).should be_persisted
        end

        it "redirects to the created data" do
          post :create, valid_request({feed_id:1, :data => valid_attributes}), valid_session
          response.should render_template("sensit/data/show")
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved data as @data" do
          # Trigger the behavior that occurs when invalid params are submitted
          ::Sensit::Node::Topic::Feed::DataRow.any_instance.stub(:save).and_return(false)
          post :create, valid_request({feed_id:1, :data => { "value" => "456" }}), valid_session
          assigns(:data).should be_a_new(::Sensit::Node::Topic::Feed::DataRow)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          ::Sensit::Node::Topic::Feed::DataRow.any_instance.stub(:save).and_return(false)
          post :create, valid_request({feed_id:1, :data => { feed_id:1, "value" => "456" }}), valid_session
          response.should render_template("sensit/data/show")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested data" do
          datum = ::Sensit::Node::Topic::Feed::DataRow.create! valid_attributes
          # Assuming there are no other data in the database, this
          # specifies that the Node::Topic::Feed::DataRow created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          ::Sensit::Node::Topic::Feed::DataRow.any_instance.should_receive(:update).with({ "value" => "456" })
          put :update, valid_request({:id => datum.to_param, :data => { "value" => "456" }}), valid_session
        end

        it "assigns the requested data as @data" do
          datum = ::Sensit::Node::Topic::Feed::DataRow.create! valid_attributes
          put :update, valid_request({:id => datum.to_param, :data => valid_attributes}), valid_session
          assigns(:data).should eq(datum)
        end

        it "redirects to the data" do
          datum = ::Sensit::Node::Topic::Feed::DataRow.create! valid_attributes
          put :update, valid_request({:id => datum.to_param, :data => valid_attributes}), valid_session
          response.should render_template("sensit/data/show")
        end
      end

      describe "with invalid params" do
        it "assigns the data as @data" do
          datum = ::Sensit::Node::Topic::Feed::DataRow.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ::Sensit::Node::Topic::Feed::DataRow.any_instance.stub(:save).and_return(false)
          put :update, valid_request({:id => datum.to_param, :data => { "value" => "456" }}), valid_session
          assigns(:data).should eq(datum)
        end

        it "re-renders the 'edit' template" do
          datum = ::Sensit::Node::Topic::Feed::DataRow.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ::Sensit::Node::Topic::Feed::DataRow.any_instance.stub(:save).and_return(false)
          put :update, valid_request({:id => datum.to_param, :data => { "value" => "456"  }}), valid_session
          response.should render_template("sensit/data/show")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested data" do
        datum = ::Sensit::Node::Topic::Feed::DataRow.create! valid_attributes
        expect {
          delete :destroy, valid_request({:id => datum.to_param}), valid_session
        }.to change(::Sensit::Node::Topic::Feed::DataRow, :count).by(-1)
      end

      it "redirects to the data list" do
        datum = ::Sensit::Node::Topic::Feed::DataRow.create! valid_attributes
        delete :destroy, valid_request({:id => datum.to_param}), valid_session
        response.status.should == 204
      end
    end

  end
end
