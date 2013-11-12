require "spec_helper"

module Sensit
    describe FeedsController do
        routes { Sensit::Api::Engine.routes }
      describe "routing" do

        it "routes to #index" do
          get("/api/nodes/1/topics/1/feeds").should route_to("sensit/feeds#index", :node_id => "1", :topic_id => "1", format: "json")
        end

        it "routes to #create" do
          post("/api/nodes/1/topics/1/feeds").should route_to("sensit/feeds#create", :node_id => "1", :topic_id => "1", format: "json")
        end

        it "routes to #show" do
          get("/api/nodes/1/topics/1/feeds/1").should route_to("sensit/feeds#show", :id => "1", :node_id => "1", :topic_id => "1", :id => "1", format: "json")
        end

        it "routes to #update" do
          put("/api/nodes/1/topics/1/feeds/1").should route_to("sensit/feeds#update", :id => "1", :node_id => "1", :topic_id => "1", :id => "1", format: "json")
        end

        it "routes to #destroy" do
          delete("/api/nodes/1/topics/1/feeds/1").should route_to("sensit/feeds#destroy", :id => "1", :node_id => "1", :topic_id => "1", :id => "1", format: "json")
        end

      end
    end
end
