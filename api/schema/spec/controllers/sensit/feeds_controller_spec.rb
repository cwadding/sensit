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
    describe FeedsController do

      before(:each) do
        @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_data write_any_data delete_any_data")
        controller.stub(:doorkeeper_token).and_return(@access_grant)
        @topic = Topic.create(:name => "MyTopic")
        field = @topic.fields.build( :key => "assf", :name => "Assf" )
        field.save
      end

      def valid_request(h = {})
        h.merge!({:use_route => :sensit_api, :format => "json", :api_version => 1})
      end
      # This should return the minimal set of attributes required to create a valid
      # ::Sensit::Topic::Feed. As you add validations to ::Sensit::Topic::Feed, be sure to
      # update the return value of this method accordingly.
      def valid_attributes
        { at: Time.now, tz: "Eastern Time (US & Canada)", values: {"assf" => "dsdsag"}}
      end

      # This should return the minimal set of values that should be in the session
      # in order to pass any filters (e.g. authentication) defined in
      # ::Sensit::Topic::FeedsController. Be sure to keep this updated too.
      def valid_session(params = {})
        {}.merge!(params)
      end

      describe "GET show" do
        it "assigns the requested feed as @feed" do
          feed = ::Sensit::Topic::Feed.create valid_attributes.merge!(index: ELASTIC_INDEX_NAME, type: @topic.to_param)
          get :show, valid_request(:id => feed.id, topic_id: @topic.to_param), valid_session(user_id: @user.to_param)
          assigns(:feed).id.should eq(feed.id)
        end
      end

      describe "POST create" do
        describe "with valid params" do
          it "creates a new ::Sensit::Topic::Feed" do
            client = ::Elasticsearch::Client.new
            expect {
              post :create, valid_request(topic_id: @topic.to_param, :feed => { :at => Time.now, :values => {"assf" => "fssa"} }), valid_session(user_id: @user.to_param)
              client.indices.refresh(:index =>  ELASTIC_INDEX_NAME)
            }.to change{::Sensit::Topic::Feed.count({index:  ELASTIC_INDEX_NAME, type: @topic.to_param})}.by(1)
          end

          context "" do
            before(:each) do
              Topic::Feed.any_instance.should_receive(:save).and_return(true)
            end

            it "assigns a newly created feed as @feed" do
              post :create, valid_request(:topic_id => @topic.to_param, :feed => { :at => Time.now, :values => {"assf" => "fssa"} }), valid_session(user_id: @user.to_param)
              assigns(:feed).should be_a(::Sensit::Topic::Feed)
              # assigns(:feed).should_not be_a_new_record
            end

            it "renders to the created feed" do
              post :create, valid_request(:topic_id => @topic.to_param, :feed => { :at => Time.now, :values => {"assf" => "fssa"} }), valid_session(user_id: @user.to_param)
              response.should render_template("sensit/feeds/show")
            end
          end
        end

        describe "with invalid params" do
          before(:each) do
            Topic::Feed.any_instance.should_receive(:save).and_return(false)
          end
          it "assigns a newly created but unsaved feed as @feed" do
            # Trigger the behavior that occurs when invalid params are submitted
            post :create, valid_request(:topic_id => @topic.to_param, :feed => { :at => Time.now, :values => {"assf" => "fssa"} }), valid_session(user_id: @user.to_param)
            assigns(:feed).should be_a_new(::Sensit::Topic::Feed)
          end

          it "re-renders the 'new' template" do
            # Trigger the behavior that occurs when invalid params are submitted
            post :create, valid_request(:topic_id => @topic.to_param, :feed => { :at => Time.now, :values => {"assf" => "fssa"} }), valid_session(user_id: @user.to_param)
            response.status.should == 422
          end
        end
      end

      describe "PUT update" do
        describe "with valid params" do
          it "updates the requested feed" do
            feed = ::Sensit::Topic::Feed.create valid_attributes.merge!(index: ELASTIC_INDEX_NAME, type: @topic.to_param)
            # Assuming there are no other feed_feeds in the database, this
            # specifies that the ::Sensit::Topic::Feed created on the previous line
            # receives the :update_attributes message with whatever params are
            # submitted in the request.
            ::Sensit::Topic::Feed.any_instance.should_receive(:update_attributes).with({"assf" => "fssa"})
            put :update, valid_request(:id => feed.id, :topic_id => @topic.to_param, :feed => { :at => Time.now, :values => {"assf" => "fssa"} }), valid_session(user_id: @user.to_param)
          end

          it "assigns the requested feed as @feed" do
            feed = ::Sensit::Topic::Feed.create valid_attributes.merge!(index: ELASTIC_INDEX_NAME, type: @topic.to_param)
            put :update, valid_request(:id => feed.id, :topic_id => @topic.to_param, :feed => { :at => Time.now, :values => {"assf" => "fssa"} }), valid_session(user_id: @user.to_param)
            assigns(:feed).id.should == feed.id
          end

          it "renders the feed" do
            feed = ::Sensit::Topic::Feed.create valid_attributes.merge!(index: ELASTIC_INDEX_NAME, type: @topic.to_param)
            put :update, valid_request(:id => feed.id, :topic_id => @topic.to_param, :feed => { :at => Time.now, :values => {"assf" => "fssa"} }), valid_session(user_id: @user.to_param)
            response.should render_template("sensit/feeds/show")
          end
        end

        describe "with invalid params" do
          it "assigns the feed as @feed" do
            feed = ::Sensit::Topic::Feed.create valid_attributes.merge!(index: ELASTIC_INDEX_NAME, type: @topic.to_param)
            # Trigger the behavior that occurs when invalid params are submitted
            ::Sensit::Topic::Feed.any_instance.stub(:save).and_return(false)
            put :update, valid_request(:id => feed.id, :topic_id => @topic.to_param, :feed => { :at => Time.now, :values => {"assf" => "fssa"} } ), valid_session(user_id: @user.to_param)
            assigns(:feed).id.should == feed.id
          end

          it "re-renders the 'edit' template" do
            feed = ::Sensit::Topic::Feed.create valid_attributes.merge!(index: ELASTIC_INDEX_NAME, type: @topic.to_param)
            # Trigger the behavior that occurs when invalid params are submitted
            ::Sensit::Topic::Feed.any_instance.stub(:save).and_return(false)
            put :update, valid_request(:id => feed.id, :topic_id => @topic.to_param, :feed => { :at => Time.now, :values => {"assf" => "fssa"} } ), valid_session(user_id: @user.to_param)
            response.status.should == 422
          end
        end
      end

      describe "DELETE destroy" do
        it "destroys the requested feed" do
          feed = ::Sensit::Topic::Feed.create valid_attributes.merge!(index: ELASTIC_INDEX_NAME, type: @topic.to_param)
          client = ::Elasticsearch::Client.new
          client.indices.refresh(index: ELASTIC_INDEX_NAME)
          expect {
            delete :destroy, valid_request(topic_id: @topic.to_param, :id => feed.id), valid_session(user_id: @user.to_param)
            client.indices.refresh(index: ELASTIC_INDEX_NAME)
          }.to change{::Sensit::Topic::Feed.count({index: ELASTIC_INDEX_NAME, type: @topic.to_param})}.by(-1)
        end

        it "redirects to the feeds list" do
          feed = ::Sensit::Topic::Feed.create valid_attributes.merge!(index: ELASTIC_INDEX_NAME, type: @topic.to_param)
          delete :destroy, valid_request(:topic_id => @topic.to_param, :id => feed.id), valid_session(user_id: @user.to_param)
          response.status.should == 204
        end
      end

    end
end
