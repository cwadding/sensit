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
      before(:each) do
        @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_data manage_any_data")
        controller.stub(:doorkeeper_token).and_return(@access_grant)
        @topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
        @feed = @topic.feeds.first
        @data_key = @feed.data.keys.first
      end

      def valid_request(h = {})
        {:use_route => :sensit_api, :format => "json", :api_version => "1"}.merge!(h)
      end

      def valid_session
        {}
      end

    describe "GET show" do
      it "renders the requested data" do
        get :show, valid_request({:id => @data_key, :feed_id => @feed.id, :topic_id => @topic.to_param}), valid_session
        response.body.should == @feed.data[@data_key].to_s
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested data" do
          client  = ::Elasticsearch::Client.new
          client.should_receive(:update).and_return({"ok" => true })
          controller.stub(:elastic_client).and_return(client)
          # ::Sensit::Topic::Feed.any_instance.should_receive(:update).with({ "value" => "456" })
          put :update, valid_request({:id => @data_key, :feed_id => @feed.id, :topic_id => @topic.to_param, :value => "sdg456" }), valid_session
        end

        it "returns an ok status" do
          client  = ::Elasticsearch::Client.new
          client.should_receive(:update).and_return({"ok" => true })
          controller.stub(:elastic_client).and_return(client)
          put :update, valid_request({:id => @data_key, :feed_id => @feed.id, :topic_id => @topic.to_param, :value => "456" }), valid_session
          response.status.should == 200
        end
      end

      describe "with invalid params" do

        it "re-renders the 'edit' template" do
          client  = ::Elasticsearch::Client.new
          client.should_receive(:update).and_return(nil)
          controller.stub(:elastic_client).and_return(client)
          put :update, valid_request({:id => @data_key, :feed_id => @feed.id, :topic_id => @topic.to_param, :value => "456" }), valid_session
          response.status.should == 422
        end
      end
    end

  end
end
