require "spec_helper"

module Sensit
  describe DataController do
        routes { Sensit::Api::Engine.routes }    
    describe "routing" do

      it "routes to #index" do
        get("/api/nodes/1/topics/1/feeds/1/data").should route_to("sensit/data#index", :node_id => "1", :topic_id => "1", :feed_id => "1",  format: "json")
      end

      it "routes to #show" do
        get("/api/nodes/1/topics/1/feeds/1/data/1").should route_to("sensit/data#show", :id => "1", :node_id => "1", :topic_id => "1",  :feed_id => "1", :id => "1", format: "json")
      end

      it "routes to #create" do
        post("/api/nodes/1/topics/1/feeds/1/data").should route_to("sensit/data#create", :node_id => "1", :topic_id => "1", :feed_id => "1",  format: "json")
      end

      it "routes to #update" do
        put("/api/nodes/1/topics/1/feeds/1/data/1").should route_to("sensit/data#update", :id => "1", :node_id => "1", :topic_id => "1", :feed_id => "1", :id => "1",  format: "json")
      end

      it "routes to #destroy" do
        delete("/api/nodes/1/topics/1/feeds/1/data/1").should route_to("sensit/data#destroy", :id => "1", :node_id => "1", :topic_id => "1", :feed_id => "1", :id => "1", format: "json")
      end

    end
  end
end
