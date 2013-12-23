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
    describe PercolatorsController do
      def valid_request(h = {})
        h.merge!({:use_route => :sensit_percolator, :format => "json", :api_version => 1})
      end
      # This should return the minimal set of attributes required to create a valid
      # ::Sensit::Topic::Percolator. As you add validations to ::Sensit::Topic::Percolator, be sure to
      # update the return value of this method accordingly.
      def valid_attributes(h={})
        { type: ELASTIC_SEARCH_INDEX_TYPE, id: "3", body: { query: { query_string: { query: 'foo' } } } }.merge!(h)
      end

      # This should return the minimal set of values that should be in the session
      # in order to pass any filters (e.g. authentication) defined in
      # ::Sensit::PercolatorsController. Be sure to keep this updated too.
      def valid_session
        {}
      end

      describe "GET show" do
        it "assigns the requested percolator as @percolator" do
          percolator = ::Sensit::Topic::Percolator.create valid_attributes
          get :show, valid_request(:id => percolator.id), valid_session
          assigns(:percolator).id.should eq(percolator.id)
        end
      end

      describe "POST create" do
        describe "with valid params" do
          it "creates a new ::Sensit::Topic::Percolator" do
            client = ::Elasticsearch::Client.new
            expect {
              post :create, valid_request(:percolator => { type: ELASTIC_SEARCH_INDEX_TYPE, :id => "mytest1", :body => {query: { query_string: { query: 'foo' } } }}), valid_session
              client.indices.refresh(:index => ELASTIC_SEARCH_INDEX_NAME)
            }.to change{::Sensit::Topic::Percolator.count({ type: ELASTIC_SEARCH_INDEX_TYPE})}.by(1)
          end

          it "assigns a newly created percolator as @percolator" do
            post :create, valid_request(:percolator => {  type: ELASTIC_SEARCH_INDEX_TYPE, :id => "mytest2", :body => {query: { query_string: { query: 'foo' } } } }), valid_session
            assigns(:percolator).should be_a(::Sensit::Topic::Percolator)
            # assigns(:percolator).should_not be_a_new_record
          end

          it "renders to the created percolator" do
            post :create, valid_request(:percolator => { type: ELASTIC_SEARCH_INDEX_TYPE, :id => "mytest3", :body => {query: { query_string: { query: 'foo' } } } }), valid_session
            response.should render_template("sensit/percolators/show")
          end
        end

        describe "with invalid params" do
          it "assigns a newly created but unsaved percolator as @percolator" do
            # Trigger the behavior that occurs when invalid params are submitted
            ::Sensit::Topic::Percolator.any_instance.stub(:save).and_return(false)
            post :create, valid_request(:percolator => { type: ELASTIC_SEARCH_INDEX_TYPE, :id => "mytest", :body => {query: { query_string: { query: 'foo' } } }  }), valid_session
            assigns(:percolator).should be_a_new(::Sensit::Topic::Percolator)
          end

          it "re-renders the 'new' template" do
            # Trigger the behavior that occurs when invalid params are submitted
            ::Sensit::Topic::Percolator.any_instance.stub(:save).and_return(false)
            post :create, valid_request(:percolator => { type: ELASTIC_SEARCH_INDEX_TYPE, :id => "mytest", :body => {query: { query_string: { query: 'foo' } } }  }), valid_session
            response.status.should == 422
          end
        end
      end

      describe "PUT update" do
        describe "with valid params" do
          it "updates the requested percolator" do
            percolator = ::Sensit::Topic::Percolator.create valid_attributes(id:4)
            # Assuming there are no other percolator_percolators in the database, this
            # specifies that the ::Sensit::Topic::Percolator created on the previous line
            # receives the :update_attributes message with whatever params are
            # submitted in the request.
            ::Sensit::Topic::Percolator.should_receive(:update).with({"id" => percolator.id, "type" => percolator.type, "body" => {"query" => { "query_string" => { "query" => 'foo' } } }  }).and_return(percolator)
            put :update, valid_request(:id => percolator.id, :percolator => { :body => {query: { query_string: { query: 'foo' } } }  }), valid_session
          end

          it "assigns the requested percolator as @percolator" do
            percolator = ::Sensit::Topic::Percolator.create valid_attributes(id:5)
            put :update, valid_request(:id => percolator.id, :percolator => { :body => {query: { query_string: { query: 'foo' } } }  }), valid_session
            assigns(:percolator).id.should == percolator.id
          end

          it "renders the percolator" do
            percolator = ::Sensit::Topic::Percolator.create valid_attributes(id:6)
            put :update, valid_request(:id => percolator.id, :percolator => { :body => {query: { query_string: { query: 'foo' } } }  }), valid_session
            response.should render_template("sensit/percolators/show")
          end
        end

        describe "with invalid params" do
          it "assigns the percolator as @percolator" do
            percolator = ::Sensit::Topic::Percolator.create valid_attributes(id:7)
            # Trigger the behavior that occurs when invalid params are submitted
            percolator.stub(:valid?).and_return(false)
            ::Sensit::Topic::Percolator.should_receive(:update).with({"id" => percolator.id, "type" => percolator.type, "body" => {"query" => { "query_string" => { "query" => 'foo' } } }  }).and_return(percolator)
            put :update, valid_request(:id => percolator.id, :percolator => { :body => {query: { query_string: { query: 'foo' } } }  } ), valid_session
            assigns(:percolator).id.should == percolator.id
          end

          it "re-renders the 'edit' template" do
            percolator = ::Sensit::Topic::Percolator.create valid_attributes(id:8)
            # Trigger the behavior that occurs when invalid params are submitted
            percolator.stub(:valid?).and_return(false)
            ::Sensit::Topic::Percolator.should_receive(:update).with({"id" => percolator.id, "type" => percolator.type, "body" => {"query" => { "query_string" => { "query" => 'foo' } } }  }).and_return(percolator)

            put :update, valid_request(:id => percolator.id, :percolator => { :body => {query: { query_string: { query: 'foo' } } }  } ), valid_session
            response.status.should == 422
          end
        end
      end

      describe "DELETE destroy" do
        it "destroys the requested percolator" do
          percolator = ::Sensit::Topic::Percolator.create valid_attributes(id:9)
          client = ::Elasticsearch::Client.new
          client.indices.refresh(:index => ELASTIC_SEARCH_INDEX_NAME)
          expect {
            delete :destroy, valid_request(:id => percolator.id), valid_session
            client.indices.refresh(:index => ELASTIC_SEARCH_INDEX_NAME)
          }.to change{::Sensit::Topic::Percolator.count({type: ELASTIC_SEARCH_INDEX_TYPE})}.by(-1)
        end

        it "redirects to the percolators list" do
          percolator = ::Sensit::Topic::Percolator.create valid_attributes(id:10)
          delete :destroy, valid_request(:id => percolator.id), valid_session
          response.status.should == 204
        end
      end

    end
end

